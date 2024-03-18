:Namespace Tatin
⍝ This script directs calls to Tatin user command to Tatin itself.
⍝ It's just an interface that does not do anything by itself.
⍝ Version 0.4.0 ⋄ 2024-03-18 ⋄ Kai Jaeger

    ∇ PrintError dummy;msg
      msg←''
      :If 3=⎕NC'⎕SE._Tatin.Reg.Version'
          msg←' Tatin is not installed correctly. Please remove and install again.'
      :EndIf
      ⎕←msg
    ∇

    ∇ r←List;ref
      r←''
      :If 9=⎕NC'⎕SE._Tatin'
          ref←GetRefToTatin''
          :If 3=ref.UC.⎕NC'List'
              r←ref.UC.List
          :Else
              PrintError''
          :EndIf
      :EndIf
    ∇

    ∇ r←level Help cmd;ref;SourceFile
      r←0⍴⊂''
      :If 9=⎕NC'⎕SE._Tatin'
          ref←GetRefToTatin''
          :If 3=ref.⎕NC'UC.List'
              r←level ref.UC.Help cmd
          :Else
              PrintError''
          :EndIf
      :Else
          ⎕←'Tatin not found'
      :EndIf
    ∇

    ∇ r←Run(cmd args);ref;SourceFile
      r←''
      SourceFile←##.SourceFile
      :If 9=⎕NC'⎕SE._Tatin'
          ref←GetRefToTatin''
          :If 3=ref.⎕NC'UC.List'
              r←ref.UC.Run(cmd args)
          :Else
              PrintError''
          :EndIf
      :Else
          ⎕←'Tatin not found'
      :EndIf
    ∇


    ∇ ref←GetRefToTatin dummy;statuse
      :If 0<⎕SE.⎕NC'Link'
          statuse←⎕SE.Link.Status''
      :AndIf 2=⍴⍴statuse
      :AndIf (⊂'#.Tatin')∊statuse[;1]
      :AndIf 0<⎕SE._Tatin.⎕NC'DEVELOPMENT'
      :AndIf (,1)≡,⎕SE._Tatin.DEVELOPMENT
          ref←#.Tatin
      :Else
          ref←⎕SE._Tatin
      :EndIf
    ∇

:EndNamespace
