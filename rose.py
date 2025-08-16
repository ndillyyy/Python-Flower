from turtle import*
import colorsys
speed(0)
pensize(2)
h=0.5
bgcolor("black")

for i in range(150):
    c= colorsys.hsv_to_rgb(h, 1,1)
    color(c)
    h+=0.004
    begin_fill()
    circle(200-i, 100)
    lt(100)
    circle(200-i, 100)
    rt(100)

for j in range(4):
    lt(100)
    rt(20)
    end_fill()
done()