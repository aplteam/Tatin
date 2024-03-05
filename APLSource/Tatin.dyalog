:Namespace Tatin

    ∇ Error;msg
      msg←''
      :If 3=⎕NC'⎕SE._Tatin.Reg.Version'
          msg←' Tatin is not installed correctly. Please remove and install again.'
      :EndIf
      ⎕←msg
    ∇

    ∇ r←List
      r←''
      :If 9=⎕NC'⎕SE._Tatin'
          :If 3=⎕NC'⎕SE._Tatin.UC.List'
              r←⎕SE.⎕SE._Tatin.UC.List
          :Else
              Error
          :EndIf
      :EndIf
    ∇

    ∇ r←level Help cmd
      r←0⍴⊂''
      :If 9=⎕NC'⎕SE._Tatin'
          :If 3=⎕NC'⎕SE._Tatin.UC.List'
              r←level ⎕SE._Tatin.UC.Help cmd
          :Else
              Error
          :EndIf
      :Else
          ⎕←'Tatin not found'
      :EndIf
    ∇

    ∇ r←Run(cmd args)        
      r←''
      :If 9=⎕NC'⎕SE._Tatin'
          :If 3=⎕NC'⎕SE._Tatin.UC.List'
              r←⎕SE._Tatin.UC.Run(cmd args)
          :Else
              Error
          :EndIf
      :Else
          ⎕←'Tatin not found'
      :EndIf
    ∇

:EndNamespace
