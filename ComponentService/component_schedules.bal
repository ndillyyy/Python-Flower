import ballerina/http;

// ====== Type Definitions ======
type Component record {|
    readonly string componentId;
    string? name;
|};

type Schedule record {|
    readonly string scheduleId;
    string? description;
|};

type Asset record {|
    readonly string assetTag;
    Component[] components = [];
    Schedule[] schedules = [];
|};

// ====== In-Memory Table ======
table<Asset> key(assetTag) assets = table [];

// ====== Listener ======
listener http:Listener listener = new(5000);

// ====== Service ======
service /assets on listener {

    // Create a new asset
    resource function post .(@http:Payload Asset newAsset) returns string {
        if assets.hasKey(newAsset.assetTag) {
            return "Asset already exists!";
        }
        assets[newAsset.assetTag] = newAsset;
        return "Asset " + newAsset.assetTag + " created successfully.";
    }

    // Add a component
    resource function post [string assetTag]/components(@http:Payload Component component) returns string {
        if assets.hasKey(assetTag) {
            Asset asset = assets[assetTag];
            asset.components.push(component);
            assets[assetTag] = asset;
            return "Component added to " + assetTag;
        }
        return "Asset not found!";
    }

    // Remove a component
    resource function delete [string assetTag]/components/[string componentId] returns string {
        if assets.hasKey(assetTag) {
            Asset asset = assets[assetTag];
            asset.components = from var c in asset.components
                               where c.componentId != componentId
                               select c;
            assets[assetTag] = asset;
            return "Component removed from " + assetTag;
        }
        return "Asset not found!";
    }

    // Add a schedule
    resource function post [string assetTag]/schedules(@http:Payload Schedule schedule) returns string {
        if assets.hasKey(assetTag) {
            Asset asset = assets[assetTag];
            asset.schedules.push(schedule);
            assets[assetTag] = asset;
            return "Schedule added to " + assetTag;
        }
        return "Asset not found!";
    }

    // Remove a schedule
    resource function delete [string assetTag]/schedules/[string scheduleId] returns string {
        if assets.hasKey(assetTag) {
            Asset asset = assets[assetTag];
            asset.schedules = from var s in asset.schedules
                              where s.scheduleId != scheduleId
                              select s;
            assets[assetTag] = asset;
            return "Schedule removed from " + assetTag;
        }
        return "Asset not found!";
    }

    // Optional: Get all assets
    resource function get .() returns Asset[] {
        return assets.toArray();
    }
}



