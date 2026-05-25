:Namespace SetItUp

    ∇ {r}←Setup arg;⎕IO;⎕ML;dmx
      r←⍬
      ⎕IO←1 ⋄ ⎕ML←1
      :If ~IfAtLeastVersion 19
      :AndIf 0=≢⎕←AutoloadTatin ⎕SE.SALTUtils.DEBUG
          {}⎕SE.SALTUtils.ResetUCMDcache -1
      :EndIf
    ∇

    ∇ r←AutoloadTatin debug;wspath;path2Config
      r←0 0⍴''
      :Trap debug/0
          :If 0=⎕SE.⎕NC'_Tatin'  ⍝ In 19.0 it most likely will already be there!
              :If ~IfAtLeastVersion 18
                  r←'Tatin not loaded: not compatible with this version of Dyalog'
              :ElseIf 80≠⎕DR' '              ⍝ Not in "Classic"
                  r←'Tatin not loaded: not compatible with Classic'
              :Else
                  ⎕SE.⎕EX¨'_Tatin' 'Tatin'
                  wspath←1 GetProgramFilesFolder '/SessionExtensions/CiderTatin/Tatin/Client.dws'
                  '_Tatin'⎕SE.⎕CY wspath
                  path2Config←⊃⎕nparts ⎕SE._Tatin.Client.FindUserSettings ⎕AN
                  'Create!'⎕SE._Tatin.Client.F.CheckPath path2Config
                  'Tatin'⎕SE.⎕NS''
                  path2Config ⎕SE._Tatin.Admin.EstablishClientInQuadSE ⍬
              :EndIf
          :EndIf
      :Else
          r←'Attempt to load Tatin failed with ',⎕DMX.EM
      :EndTrap
    ∇

      IfAtLeastVersion←{
      ⍝ ⍵ is supposed to be a number like 15 or 17.1, representing a version of Dyalog APL.
      ⍝ Returns a Boolean that is 1 only if the current version is at least as good.
          ⍵≤{⊃(//)⎕VFI ⍵/⍨2>+\'.'=⍵}2⊃# ⎕WG'APLVersion'
      }

    ∇ r←{versionAgnostic}GetProgramFilesFolder postFix;version;aplVersion;OS
      ⍝ Returns the path to Dyalog's version-specific program files folder.\\
      ⍝ Works on all platforms but returns different results.\\
      ⍝ Under Windows typically:\\
      ⍝ `C:\Users\<⎕AN>\Documents\Dyalog APL[-64] 19.0 Unicode Files' ←→ GetMyUCMDsFolder
      ⍝ ⍺ is optional and defaults to 0, meaning the version-agnostic folder is returned.
      ⍝ If ⍺←1, the folder associated with the currently running version of Dyalog is returned.
       versionAgnostic←{0<⎕NC ⍵:⍎⍵ ⋄ 0}'versionAgnostic'
       OS←3↑1⊃# ⎕WG'APLVersion'
       postFix←{(((~'/\'∊⍨⊃⍵)∧0≠≢⍵)/'/'),⍵}postFix
       aplVersion←# ⎕WG'APLVersion'
       :If versionAgnostic
           :If OS≡'Win'
               version←((∨/'-64'⍷1⊃aplVersion)/'-64'),' ',({⍵/⍨2>+\⍵='.'}2⊃aplVersion),' ',(80=⎕DR' ')/'Unicode'
               r←(2 ⎕NQ #'GetEnvironment' 'USERPROFILE'),'\Documents\Dyalog APL',version,' Files',postFix
           :Else
               version←({'.'~⍨⍵/⍨2>+\⍵='.'}2⊃aplVersion),((80=⎕DR' ')/'U'),((1+∨/'-64'⍷1⊃aplVersion)⊃'32' '64')
               r←(⊃⎕SH'echo $HOME'),'/dyalog.',version,'.files',postFix
           :EndIf
       :Else
           :If OS≡'Win'
               r←(2 ⎕NQ #'GetEnvironment' 'USERPROFILE'),'\Documents\Dyalog APL Files',postFix
           :Else
               r←(⊃⎕SH'echo $HOME'),'/dyalog.files',postFix
           :EndIf
       :EndIf
   ∇

:EndNamespace
