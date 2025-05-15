:Namespace activate ⍝ v0.4.0
⍝ Pre-packaged tool activation
⍝ 2023-09-25
⍝ 2023-11-02 kai: `Run` must go into StartupSession/ rather than SessionExtensions/
⍝ 2023-11-06 kai: One can now -reset or deactivate just one of Cider/Tatin
⍝ 2024-01-15 adam: [21074] always return result
⍝ 2024-06-05 AndyS: [21422] Gracefully and informatively fail if run on AIX or on Classic interpreters; remove reference to -update in Help
⍝ 2025-03-12 kai: .dyalog/ fixed, -versionagnostic flag added, -update flag removed, ]deactivate polished, ]ListActivated added

    ⎕IO←1 ⋄ ⎕ML←1   ⍝ Set those here to avoid inheriting them from outside
    AllCmds←'Activate' 'Deactivate' 'ListActivated'

    ∇ r←List ⍝ this function usually returns 2 or more namespaces (here only 2)
      r←⎕NS¨0/¨AllCmds                             ⍝ create commands
      r.Name←AllCmds                               ⍝ their names
      r[1].Desc←'Activate or reset an experimental tool shipped with Dyalog APL'
      r[2].Desc←'Deactivate a previously activated tool'
      r[3].Desc←'List all activated tools with their folders'
      r.Group←⊂'Tools'
     ⍝ Parsing rules for each:
      r[1].Parse←'1 -reset -versionagnostic'
      r[2].Parse←'1'
      r[3].Parse←'-raw'
    ∇

    ∇ r←Level Help Cmd;t
      :Select ⎕C Cmd
     
      :Case ⎕C'Activate'
          r←,⊂'Activate an experimental tool shipped with Dyalog APL 19.0'
          r,←⊂'    ]',Cmd,' cider|tatin|all -reset -versionagnostic'
          r,←⊂''
          r,←⊂'By default a tool is activated for the currently running version of Dyalog, but check -versionagnostic.'
          r,←⊂'If you want to get rid of a tool (or all tools), check the ]Deactivate command.'
          r,←⊂''
          r,←⊂' -versionagnostic   Installs into a version-agnostic folder of Dyalog.'
          r,←⊂'                    Use this if you want to use a tool from more than one version'
          r,←⊂'                    of Dyalog and load them from the same source folder.'
          r,←⊂'                    Note that you cannot activate in both locations.'
          r,←⊂' -reset             Revert to the version shipped with APL.'
     
      :Case ⎕C'Deactivate'
          r←,⊂'Deactivate all or some previously ]Activate''d tools'
          r,←⊂'    ]',Cmd,' all|tatin|cider'
          r,←⊂''
          r,←⊂'Removes from both the version-specific and the version-agnostic folder.'
          r,←⊂''
          r,←⊂'Note that you cannot Deactivate Tatin while Cider is still activated because Cider depends on Tatin.'
     
      :Case ⎕C'ListActivated'
          r←,⊂'List all tools ativated anywhere (version specific and version agnostic)'
          r,←⊂''
          r,←⊂'With the -raw flag you get a boolean matrix rather than textual information:'
          r,←⊂'Row:  Tatin, Cider'
          r,←⊂'Cols: specific, agnostic (version)'
     
      :EndSelect
    ∇

    ∇ r←Run(Cmd Args);tool;target;source;m;src;z;rid;s;target2;cmddir;sep;folder;agnostic;raw;APLV
      APLV←'.'⎕WG'APLVersion'
      DYALOG←2 ⎕NQ'.' 'GetEnvironment' 'DYALOG'
      APLV←'.'⎕WG'APLVersion'
      :If 19>⊃2⊃'.'⎕VFI 2⊃APLV
          →0⊣r←'This user command requires Dyalog version 19.0 or later'
      :EndIf
      :If 'listactivated'≡⎕C Cmd
          raw←Args.Switch'raw'
          r←ListActivated raw
      :Else
          :If 'AIX'≡3↑⊃APLV
              →0⊣r←'Neither this user command nor Tatin/Cider are supported on AIX'
          :EndIf
     
          :If 82=⎕DR''
              →0⊣r←'Neither this user command nor Tatin/Cider are supported on Classic interpreters'
          :EndIf
     
          tool←⎕C Args._1
          :If ~(⊂tool)∊'all' 'cider' 'tatin'
              →0⊣r←'Tool must be one of all|cider|tatin'
          :EndIf
          :Select Cmd
          :Case 'Activate'
              agnostic←Args.Switch'versionagnostic'
              (target target2)←GetFolders agnostic
              :If Args.reset
                  Reset tool target target2
              :EndIf
              r←Activate(tool agnostic target target2)
          :Case 'Deactivate'
              r←Deactivate tool
          :Else
              r←'Command not found: ',Cmd
          :EndSelect
      :EndIf
    ∇

    ∇ r←Deactivate tool;b;target_a;target_b;target_a2;target_b2;home;cmddir;sep;orig;flag2;flag1
      r←''
      (target_a target_a2)←GetFolders 0     ⍝ Version specific
      (target_b target_b2)←GetFolders 1     ⍝ Version agnostic
      b←⎕NEXISTS target_a target_b
      :If 0=+/b
          →0⊣r←'Neither Tatin nor Cider are activated'
      :EndIf
      :If ~(⊂tool)∊'all' 'cider'
      :AndIf 1∧.=⎕NEXISTS(target_a,'/Cider')(target_b,'/Cider')
          →0⊣r←'Tool name must be either "all" or "cider" to deactivate'
      :EndIf
      :If 'tatin'≡tool
      :AndIf ∨/⎕NEXISTS(target_a,'/Cider')(target_b,'/Cider')
          →0⊣r←'You cannot deactivate Tatin while Cider is active'
      :EndIf
      :If 'cider'≡tool
          target_a,←'/Cider'
          target_b,←'/Cider'
      :EndIf
      :If ⎕NEXISTS target_a
          3 ⎕NDELETE target_a
          r,←'"',target_a,'" deleted',CR
      :EndIf
      :If ⎕NEXISTS target_b
          3 ⎕NDELETE target_b
          r,←'"',target_b,'" deleted',CR
      :EndIf
      :If 'all'≡tool
      :OrIf (~⎕NEXISTS target_a)∧'tatin'≡tool
          :If ⎕NEXISTS target_a2
              3 ⎕NDELETE target_a2
          :EndIf
      :EndIf
      :If 'all'≡tool
      :OrIf (~⎕NEXISTS target_b)∧'tatin'≡tool
          :If ⎕NEXISTS target_b2
              3 ⎕NDELETE target_b2
          :EndIf
      :EndIf
      :If (⊂tool)∊'all' 'tatin'
          sep←(1+'Win'≡3↑⊃APLV)⊃':;'
          cmddir←orig←GetSaltsCmdDir sep
          home←GetHomeFolder 0
          flag1←flag2←0
          :If ~⎕NEXISTS home,'/SessionExtensions/CiderTatin'
          :AndIf (⊂target_a)∊cmddir
              cmddir~←⊂target_a
              flag1←1
          :EndIf
          home←GetHomeFolder 1
          :If ~⎕NEXISTS home,'/SessionExtensions/CiderTatin'
          :AndIf (⊂target_b)∊cmddir
              cmddir~←⊂target_b
              flag2←1
          :EndIf
          cmddir←1↓⊃,/sep,¨cmddir
          :If orig≢cmddir
              {}⎕SE.SALT.Set'cmddir "',cmddir,'" -permanent'
              r,←'cmddir set to: '
              r,←(CR,' "')∘,¨(sep(≠⊆⊢)cmddir),¨'"'
          :EndIf
      :EndIf
      :If 0=≢r
          r←'No change required - not active.'
      :Else
          r,←CR,'Restart APL to complete deactivation.'
      :EndIf
    ∇

    ∇ r←Activate(tool agnostic target target2);source;folder;m;src;sep;cmddir;z;mat
      r←''
      :If 'all'≡tool
      :AndIf ⎕NEXISTS target
          →0⊣r←'Folder "',target,'" exists, please specify -reset'
      :EndIf
      :If 'tatin'≡tool
      :AndIf ⎕NEXISTS target,'/Tatin'
          →0⊣r←'Folder "',target,'/Tatin" exists, please specify -reset'
      :EndIf
      :If 'cider'≡tool
      :AndIf ⎕NEXISTS target,'/Cider'
          →0⊣r←'Folder "',target,'/Cider" exists, please specify -reset'
      :EndIf
      mat←ListActivated_ ⍬
      :If 0<+/mat[1+~agnostic;]
          →0⊣r←'Already installed in version-',((1+agnostic)⊃'specific' 'agnostic'),' folder: ',⊃{⍺,',',⍵}/mat[1+~agnostic;]/'Tatin' 'Cider'
      :EndIf
      source←''
      folder←DYALOG,'/Experimental/CiderTatin/'
      :If (⊂tool)∊'tatin' 'all'
          source,←⊂folder,'Tatin'
      :EndIf
      :If (⊂tool)∊'cider' 'all'
          source,←⊂folder,'Cider'
      :EndIf
      :If tool≡'cider'
      :AndIf 0=+/⎕NEXISTS target target2,¨⊂'/Tatin'
          →0⊣r←'Tatin is not activated but a requirement for Cider'
      :EndIf
     ⍝ Tatin and Run are always copied, Cider only if "tool" is "cider" or "all"
      :If ~m←⎕NEXISTS src←folder
      :OrIf ~∧/m←⎕NEXISTS src←source
          →0⊣r←'Tool source not found: ',⍕(~m)/src
      :EndIf
      3 ⎕MKDIR target
      target ⎕NCOPY source
      source←folder,'Run.aplf'
      r,←tool,' activated...',CR
      :If ~⎕NEXISTS target2
          3 ⎕MKDIR target2
          target2 ⎕NCOPY source
          r,←'Cider activated...',CR
      :EndIf
      sep←(1+'Win'≡3↑⊃APLV)⊃':;'
      cmddir←GetSaltsCmdDir sep
      target←PolishPath target
      :If ~(⊂target)∊cmddir
          cmddir,←⊂target
          cmddir←∪sep,¨cmddir
          z←⎕SE.SALT.Set'cmddir "',(1↓⊃,/cmddir),'" -permanent'
          r,←'cmddir set to: '
          r,←(CR,' "')∘,¨cmddir,¨'"'
          r,←CR
      :EndIf
      r,←'Restart APL to complete activation.',CR
    ∇

    ∇ r←ListActivated raw;spaces;mat
    ⍝ List all activated tools, version specific and version agnostic
      mat←ListActivated_ ⍬
      :If raw
          r←mat
      :Else
          r←⊂'--- Report on Tatin and Cider'
          :If 0=+/,mat
              r←'Neither Tatin nor Cider are activated'
          :Else
              r,←⊂' * Version-specific'
              spaces←3⍴' '
              r,←⊂spaces,'Tatin: ',((~mat[1;1])/'not '),'activated'
              r,←⊂spaces,'Cider: ',((~mat[1;2])/'not '),'activated'
              r,←⊂' * Version-agnostic'
              r,←⊂spaces,'Tatin: ',((~mat[2;1])/'not '),'activated'
              r,←⊂spaces,'Cider: ',((~mat[2;2])/'not '),'activated'
              r←⊃,/r,¨CR
          :EndIf
      :EndIf
    ∇

    ∇ mat←ListActivated_ dummy;target1;target2
    ⍝ Returns a boolean matrix with two rows (version-specific, version agnostic) and two columns (Tatin, Cider)
    ⍝ indicating activation (1) or not (0)
      mat←2 2⍴0
      target1←⊃GetFolders 0
      target2←⊃GetFolders 1
      mat[1;]←⎕NEXISTS target1∘,¨'/Tatin' '/Cider'
      mat[2;]←⎕NEXISTS target2∘,¨'/Tatin' '/Cider'
    ∇

    ∇ (target target2)←GetFolders agnostic;home
      home←GetHomeFolder agnostic
      target←PolishPath home,'/SessionExtensions/CiderTatin'  ⍝ Cider & Tatin
      target2←PolishPath home,'/StartupSession/CiderTatin'    ⍝ For the associated `Run` function
    ∇

    ∇ {r}←Reset(tool target target2);target;target2
    ⍝ Deletes the given activated tools so that the activation will restore the version APL was shiped with
      r←0
      :Select tool
      :Case 'cider'
          3 ⎕NDELETE target,'/Cider'
      :Case 'tatin'
          3 ⎕NDELETE target,'/Tatin'
          3 ⎕NDELETE target2,'/Run.apl'
      :Case 'all'
          3 ⎕NDELETE target
          3 ⎕NDELETE target2,'/Run.apl'
      :EndSelect
    ∇

    ∇ home←GetHomeFolder agnostic;rid
      :If 'Win'≡3↑⊃APLV
          :If agnostic
              home←(1⊃⎕NPARTS 2⊃4070⌶⍬),'Dyalog APL Files'
          :Else
              home←2⊃4070⌶⍬
          :EndIf
      :Else
          :If agnostic
              home←(2 ⎕NQ #'GetEnvironment' 'HOME'),'/dyalog.files'
          :Else
              rid←(3↑⎕D∩⍨2⊃APLV),((1+80=⎕DR'A')⊃'CU'),(1+1∊'64'⍷1⊃APLV)⊃'32' '64'
              home←(2 ⎕NQ #'GetEnvironment' 'HOME'),'/dyalog.',rid,'.files'
          :EndIf
      :EndIf
    ∇

    ∇ cmddir←GetSaltsCmdDir sep
      cmddir←⎕SE.SALT.Settings'cmddir'
      cmddir←sep(≠⊆⊢)cmddir
      cmddir←PolishPath¨cmddir
    ∇

    ∇ path←PolishPath path;slashes
      slashes←('Win'≡3↑⊃APLV)⌽'\/'
      ((slashes[1]=path)/path)←slashes[2]
      path←slashes{(-(⊃¯1↑⍵)∊⍺)↓⍵}path
      path←'\\\\'⎕R'\\'⊢path             ⍝ Just in case....
    ∇

    ∇ r←CR
      r←⎕UCS 13
    ∇

:EndNamespace
