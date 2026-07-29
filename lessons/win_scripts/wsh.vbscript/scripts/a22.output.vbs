' VBScript has no heredoc/triple-quote syntax - a "&"-continued chain of
'  lines (continued with " _", joined with vbCrLf) is the closest
'  stand-in for a multi-line string literal, passed straight to
'  wscript.stdout.write as its argument. A literal quote inside a
'  string is written "" (a doubled quote), VBScript's own escape for one.
wscript.stdout.write """The person who moves a mountain begins" & vbCrLf & _
       " by carrying away small stones.""" & vbCrLf & _
       "" & vbCrLf & _
       "   - Confucious" & vbCrLf & _
       "" & vbCrLf & _
       """Yesterday I was clever, so I wanted to change the world." & vbCrLf & _
       " Today I am wise, so I am I changing myself.""" & vbCrLf & _
       "" & vbCrLf & _
       "   - Rumi" & vbCrLf & _
       "" & vbCrLf & _
       """Action speaks louder than words," & vbCrLf & _
       "   but not nearly as often.""" & vbCrLf & _
       "" & vbCrLf & _
       "   - Mark Twain" & vbCrLf & _
       "" & vbCrLf & _
       """A designer knows he has achieved perfection" & vbCrLf & _
       " not when there is nothing left to add, but" & vbCrLf & _
       " when there is nothing left to take away.""" & vbCrLf & _
       "" & vbCrLf & _
       "   - Antoine de Saint-Exupery" & vbCrLf & _
       "" & vbCrLf & _
       """There is no greater wealth than wisdom," & vbCrLf & _
       " no greater poverty than ignorance""" & vbCrLf & _
       "" & vbCrLf & _
       "   - Ali bin Abu-Talib" & vbCrLf & vbCrLf
