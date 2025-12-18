##References
https://en.wikibooks.org/wiki/OpenSCAD_User_Manual/Importing_Geometry/SVG_Impor

##Approach
- Load svg file, expand it in 2D using minkowslik. Subtract the original to get
  the outline. Linear extrude it to get the wall. Add on the base, which is
  linear extruded expanded shape.
- Challenge: how to get accurate dimensions. The SVG file had `viewBox in it`:
    ```
    <svg id="Layer_1" data-name="Layer 1" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 864 864">
    ```
    WIthout scaling info, this will be interpreted as 864 mm x 864 mm, I think. Fix is to set dpi = a value you want.
- Unfortunately above strategy causes an erro ??? when duing full render only when I union it with the base plate, even a simple base plate. Technically it shouldn't happen.
    -- Verified that a simple rect svg doesn't have this issue.
- Simply extruding the path twice fails. My theory is that the extruded 3d shape is not closed. So *any* boolean operation doesn't work. But 
- I created a fat R shape in Inkscape by converting the text to path. This one OpenSCAD happily processes all the way to the generated STL file.
- So there's something about the dancer outline that's not good, even though it renders as a closed path with holes in both Inkscape and OpenSCAD!
- I simplified the mesh in Inkscape and it still behaved the same way :-(
