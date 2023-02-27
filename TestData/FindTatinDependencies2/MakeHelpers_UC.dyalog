:Class MakeHelpers_UC
⍝ Puts MakeHelper's internal documentation on display

    ⎕IO←⎕ML←1

    ∇ r←List;c
      :Access Shared Public
      r←⍬
     
      c←⎕NS''
      c.Name←'MakeHelpers'
      c.Desc←'MakeHelpers offers helpers for creating a new version of a package or an application or something in between via its API'
      c.Group←'TOOLS'
      c.Parse←''
      r,←c
    ∇

    ∇ r←Run(Cmd Args)
      :Access Shared Public
      r←''
      ⎕SE.UCMD'ADOC ⎕se.MakeHelpers.## -title=MakeHelpers'
    ∇

    ∇ r←level Help Cmd;⎕IO;⎕ML
      ⎕IO←⎕ML←1
      :Access Shared Public
      r←''
      :Select level
          r,←⊂']MakeHelpers'
      :Case 1
          r,←⊂'Puts the internal documentation on display'
      :EndSelect
    ∇  

:EndClass
