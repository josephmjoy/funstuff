#TODO
1. Create a basic pattern that contains cuts and engraving. Test that this works in Glowforge.
1. Get basic shapes for cutting tiles in place - a grid of rounded rectangles
2. Figure out how to add the bmp file for  Albert. Maybe best to have it
   changed to lines? Or leave that to Inkscape.


# SVG Paths
I don't think it's necessary to create SVG paths. Instead just inject a bunch of lines and 
It seems that it is a linear sequence - so a single line, though it
may twist and turn. This means that we have to create our rounded tiles by
creating a set of paths, whose
This is a useful article: `https://jackforge.com/glowforge-order-of-operations-ai/`. From the article:
- Strokes produce cuts.
- Fills produce engravings.
- Engravings are scheduled before cuts (makes sense, as we don't want cuts to cause free pieces to move before engraving).

To engrave anything, the elements have to be objects that can be filled. We should see what happens to generated SVG if we use beginShape() and endShape().
See also: https://processing.org/tutorials/pshape. It seems that you can load and compose shapes, including by loading an SVG file!

For now, I don't think this applies to generating cut+engrave files. The plan now is just to focus on cut files, and then see how to 


Arc mode: OPEN, noFill:
Font: Cooper black. 16 point. It has fewest sharp edges and narrow spaces (which can peel off), and narrow lines (which can get filled in with paint).


SVG Units:
- Really illuminating post on `https://graphicdesign.stackexchange.com/questions/84163/svg-and-viewbox-values#:~:text=Inkscape%20uses%20mm%20as%20the%20default%20display-unit%20or,describes%20a%20drawing%20size%20of%20100px%20x%20100px`.
- Key is that per CSS specifications (according the above post), DPI is
  set to 96. So that's how pixels are interpreted. Inkscape adopts this - so,
  for example, if Processing generates a 96 pixel-wide SVG rectangle, it will
  be exactly 1 inch when loaded into Inkscape. I verified this.
