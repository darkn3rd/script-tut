#!/usr/bin/env bash
# Store Multi-line Text bash here string
read -r -d '' phrases <<'END'
"The person who moves a mountain begins 
 by carrying away small stones."  

   - Confucious

"Yesterday I was clever, so I wanted to change the world. 
 Today I am wise, so I am I changing myself."

   - Rumi

"Action speaks louder than words,
   but not nearly as often." 

   - Mark Twain

"A designer knows he has achieved perfection 
 not when there is nothing left to add, but 
 when there is nothing left to take away."  

   - Antoine de Saint-Exupery

"There is no greater wealth than wisdom, 
 no greater poverty than ignorance" 

   - Ali bin Abu-Talib
END

echo "$phrases"