# Generating Calendars and Planners with Google Gemini

## 2026 Jan 20
This is the conversation I had with Gemini:
https://gemini.google.com/share/03568ce2d238
Generated calender for Jan and 2-month calendar for jan-feb and mar-apr - the latter have 23x14, so suitable for
my large-format HP DesignJet printer.

The SVG is nicely structured, with different classes of elements (lines, heading, weekdays, and numeric days)
each having named styles:
```
  <defs>
    <style>
      .border { fill: none; stroke: #000; stroke-width: 2; }
      .grid { fill: none; stroke: #888; stroke-width: 1; }
      .header-text { font-family: sans-serif; font-size: 36px; font-weight: bold; text-anchor: middle; }
      .day-label { font-family: sans-serif; font-size: 18px; font-weight: bold; text-anchor: middle; }
      .date-number { font-family: sans-serif; font-size: 16px; fill: #333; }
    </style>
  </defs>
```
