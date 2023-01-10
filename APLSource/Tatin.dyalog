:Namespace Tatin
⍝ The ]Tatin user commands for managing packages.\\
⍝ * 0.56.0 - 2023-01-06

    ⎕IO←1 ⋄ ⎕ML←1

    NM←'tatin'
    RS←'#._tatin' ⍝ target Root Space for packages
    SupportedExtensions←'.aplc' '.apln' '.apli' '.aplf' '.aplo' '.apla' '.charlist' '.charmat' '.charstring' '.dyalog'
    RegKey←'HKCU\Software\Tatin\ConfigPath'
    tatinURL←'https://tatin.dev'

    ErrNo←998

    ∇ r←List;c
      r←⍬
     
      :If IfAtLeastVersion 18
     
          c←⎕NS ⍬
          c.Name←'BuildPackage'
          c.Desc←'Build a new version of a package (zips) all required files in ⍵[1] into the folder ⍵[2]'
          c.Parse←'2s -dependencies= -version='
          r,←c
     
          c←⎕NS ⍬
          c.Name←'CreatePackage'
          c.Desc←'Create a new Tatin package'
          c.Parse←'1s'
          r,←c
     
          c←⎕NS ⍬
          c.Name←'DeprecatePackage'
          c.Desc←'Declare a package as deprecated'
          c.Parse←'2 -force'
          r,←c
     
          c←⎕NS ⍬
          c.Name←'FindDependencies'
          c.Desc←'Search the folder for given packages and report installed packages'
          c.Parse←'2 -detailed'
          r,←c
     
          c←⎕NS ⍬
          c.Name←'LoadTatin'
          c.Desc←'Load the Tatin client into ⎕SE, resulting in ⎕SE.Tatin, and initializes it'
          c.Parse←'1s -force'
          r,←c
     
          c←⎕NS ⍬
          c.Name←'ListDeprecated'
          c.Desc←'List all deprecated packages (major versions only)'
          c.Parse←'1s -all'
          r,←c
     
          c←⎕NS ⍬
          c.Name←'ListRegistries'
          c.Desc←'List all registries defined in the user settings'
          c.Parse←'0 -full'
          r,←c
     
          c←⎕NS ⍬
          c.Name←'ListPackages'
          c.Desc←'List all packages in the Registry or install folder specified in the argument'
          c.Parse←'1s -group= -tags= -os= -noaggr -date -project_url -since='
          r,←c
     
          c←⎕NS ⍬
          c.Name←'LoadPackages'
          c.Desc←'Load the package(s) specified in the argument and all dependencies into the WS or ⎕SE'
          c.Parse←'1-2 -nobetas'
          r,←c
     
          c←⎕NS ⍬
          c.Name←'ListVersions'
          c.Desc←'List all versions of the specified package or all versions of a particular Registry'
          c.Parse←'1 -date'
          r,←c
     
          c←⎕NS ⍬
          c.Name←'InstallPackages'
          c.Desc←'Install one or more packages and all its dependencies into a given folder'
          c.Parse←'1-2 -nobetas -quiet'
          r,←c
     
          c←⎕NS ⍬
          c.Name←'LoadDependencies'
          c.Desc←'Take a folder (⍵[1]) with installed packages and loads all of them into ⍵[2]'
          c.Parse←'1-2 -overwrite'
          r,←c
     
          c←⎕NS ⍬
          c.Name←'Maintenance'
          c.Desc←'Checks whether there is a maintenance file to be executed'
          c.Parse←'1s -dry -show'
          r,←c
     
          c←⎕NS ⍬
          c.Name←'UserSettings'
          c.Desc←'The user settings and the fully qualified filenanme are printed to ⎕SE as JSON'
          c.Parse←'0 -edit -apikey -refresh'
          r,←c
     
          c←⎕NS ⍬
          c.Name←'PackageConfig'
          c.Desc←'Retrieve (via HTTP) or create and/or edit a package config file for a specific package'
          c.Parse←'1s -delete -edit -quiet'
          r,←c
     
          c←⎕NS ⍬
          c.Name←'PackageDependencies'
          c.Desc←'Create and/or edit a package dependency file for a specific folder'
          c.Parse←'1 -delete -edit -quiet'
          r,←c
     
          c←⎕NS ⍬
          c.Name←'PublishPackage'
          c.Desc←'Publish a package (package folder or ZIP file) to a particular Registry'
          c.Parse←'2 -dependencies='
          r,←c
     
          c←⎕NS ⍬
          c.Name←'Version'
          c.Desc←'Print name, version number and version date of the client to the session'
          c.Parse←'1s -check -all'
          r,←c
     
          c←⎕NS ⍬
          c.Name←'ListTags'
          c.Desc←'List all tags used in all packages'
          c.Parse←'1s -tags= -os='
          r,←c
     
          c←⎕NS ⍬
          c.Name←'Init'
          c.Desc←'(Re)-establish the user settings'
          c.Parse←'1s'
          r,←c
     
          c←⎕NS ⍬
          c.Name←'CheckForLaterVersion'
          c.Desc←'Check whether there are later versions of a package available'
          c.Parse←'1 -major -dependencies'
          r,←c
     
          c←⎕NS ⍬
          c.Name←'Documentation'
          c.Desc←'Load the documentation center into the default browser'
          c.Parse←''
          r,←c
     
          c←⎕NS ⍬
          c.Name←'DeletePackage'
          c.Desc←'Delete a package from a Tatin Registry'
          c.Parse←'1'
          r,←c
     
          c←⎕NS ⍬
          c.Name←'GetDeletePolicy'
          c.Desc←'Ask the server about its "Delete" policy'
          c.Parse←'1s -check'
          r,←c
     
          c←⎕NS ⍬
          c.Name←'UnInstallPackage'
          c.Desc←'Un-install a package, and implicitly its dependencies'
          c.Parse←'2s -cleanup -quiet'
          r,←c
     
          c←⎕NS ⍬
          c.Name←'UpdateTatin'
          c.Desc←'Attempt to update the Tatin client and reports the result'
          c.Parse←''
          r,←c
     
          c←⎕NS ⍬
          c.Name←'ReInstallDependencies'
          c.Desc←'Install all packages again according to the dependency file'
          c.Parse←'2s -nobetas -dry -force -update'
          r,←c
     
          c←⎕NS ⍬
          c.Name←'Ping'
          c.Desc←'Ping Tatin server(s) with very little overhead'
          c.Parse←'1s'
          r,←c
     
          c←⎕NS ⍬
          c.Name←'Cache'
          c.Desc←'List contents of the Tatin package cache'
          c.Parse←'1s -clear -path -force'
          r,←c
     
          c←⎕NS ⍬
          c.Name←'UsageData'
          c.Desc←'Make usage data available for the specified Tatin Registry'
          c.Parse←'1s -download -unzip -all -folder='
          r,←c
     
          r.Group←⊂NM
     
      :EndIf
     
    ∇

    ∇ {r}←Run(Cmd Input)
      :If Run_ Cmd Input
          r←((⍎Cmd)__ExecAsTatinUserCommand)Input
      :EndIf
    ∇

    ∇ r←Run_(Cmd Input);ns
      r←0
      :If 0=⎕SE.⎕NC'Link.Version'
      :OrIf 3>⊃(//)⎕VFI{⍵↑⍨¯1+⍵⍳'.'}⎕SE.Link.Version
          'Tatin requires at least Link 3.0'⎕SIGNAL ErrNo
      :EndIf
      :If 0=⎕SE.⎕NC'Tatin'
      :AndIf ≢/⎕C¨'LoadTatin'Cmd
          LoadTatin''
      :EndIf
      :If ≡/⎕C¨'loadtatin'Cmd
          Input.force LoadTatin(1+(0≡Input._1)∨0=≢Input._1)⊃Input._1''
      :Else
          TC←⎕SE._Tatin.Client
          :If 0=⎕SE._Tatin.RumbaLean.⎕NC'DRC'
              ⎕SE._Tatin.Admin.InitConga ⍬
          :EndIf
          r←1
      :EndIf
    ∇


    ∇ r←(fns __ExecAsTatinUserCommand)arg
    ⍝ Fancy name so that we can work out whether a Tatin function was called via the User Command framework.
    ⍝ That makes a difference regarding messages printed to the session (if at all).
     
      r←fns arg   ⍝ <===
     
    ⍝Done
    ∇

    ∇ {r}←{forceLoad}LoadTatin path2Config;buff;home;settings
      r←1
      forceLoad←{0<⎕NC ⍵:⍎⍵ ⋄ 0}'forceLoad'
      LoadTatin_ forceLoad
      home←⍎'Tatin'⎕SE.⎕NS''
      :If 0=≢path2Config
          path2Config←TC.FindUserSettings ⎕AN
      :EndIf
      'Create!'TC.F.CheckPath path2Config
      path2Config ⎕SE._Tatin.Admin.EstablishClientInQuadSE home
     ⍝Done
    ∇

    ∇ r←Version Arg;registries;registry;alias;qdmx
      :If Arg.check
          r←1 TC.GetServerVersion Arg._1
      :Else
          :If (,'*')≡,Arg._1
          :OrIf Arg.all
              r←⊂(⊂'{Client}'),TC.Reg.Version
              registries←1 TC.ListRegistries 0
              :For registry alias :In ↓registries[;1 2]
                  :If 0≠≢'http[s]://'⎕S 0⊣registry  ⍝ Not local?
                      :Trap 0
                          r,←⊂(⊂registry),TC.GetServerVersion registry
                      :Else
                          r,←⊂registry'' '*** Could not be accessed'
                      :EndTrap
                  :EndIf
              :EndFor
              r←(↑r)[;1 3 4]
          :ElseIf 0≡Arg._1
              r←TC.Reg.Version
          :ElseIf (,'?')≡,Arg._1
              →(⍬≡registry←SelectRegistry 0)/0
              registry←EnforceSlash registry
              r←TC.GetServerVersion registry
          :Else
              r←TC.GetServerVersion Arg._1
          :EndIf
      :EndIf
    ∇

    ∇ {r}←LoadTatin_ forceLoad;filename
      r←1
      filename←(1⊃⎕NPARTS ##.SourceFile),'/Client.dws'
      :If 0∊⊃∘⎕SE.⎕NC¨'Tatin' '_Tatin'
      :OrIf forceLoad
          ('Workspace not found: ',filename)⎕SIGNAL ErrNo/⍨0=⎕NEXISTS filename
          ⎕SE.⎕EX¨'_Tatin' 'Tatin'
          '_Tatin'⎕SE.⎕CY filename
      :EndIf
      TC←⎕SE._Tatin.Client
    ∇

⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝ Methods

    ∇ r←Maintenance Arg;dry;path;home;⎕TRAP;show;filename;body;list;ind
      (dry show)←Arg.(dry show)
      path←Arg._1
      home←1⊃⎕NPARTS ##.SourceFile
      :If show
          :If 0=≢list←TC.F.ListFiles home,'Maintenance/*.aplf'
              r←'There are no Tatin maintenance files'
          :Else
              r←''
              :For filename :In list
                  body←1↓⊃TC.F.NGET filename 1
                  r,←⊂'*** ',filename
                  body←(';'≠⊃¨TC.A.DLB body)/body
                  body←(+/∧\'⍝'=⊃¨body)↑body
                  r,←2↓¨body
                  r,←⊂(⎕PW-2)⍴'-'
              :EndFor
              r←⍪r
          :EndIf
      :Else
          'You must specify a path'Assert 0≢path
          ('Is not a folder: ',path)Assert TC.F.IsDir path
          :If 0=≢list←TC.F.ListFiles home,'Maintenance/*.aplf'
              r←'No maintenance files found in ',home
          :Else
              list←⌽list
              :If 0<≢ind←'Which maintenance functions would you like to execute?' 1 0 TC.CommTools.Select{2⊃⎕NPARTS ⍵}¨list
                  list←list[ind]
                  :If 0=≢r←TC.Maintenance path dry list
                      r←'No packages found to be changed'
                  :EndIf
              :Else
                  r←'No maintenance function(s) selected'
              :EndIf
          :EndIf
      :EndIf
    ∇

    ∇ {r}←CreatePackage Arg;path;filename
      r←'For creating a new package execute this user command:'
      :If (,0)≡,Arg._1
          r,←CR,'      ]Tatin.PackageConfig -edit'
      :Else
          r,←CR,'      ]Tatin.PackageConfig ',Arg._1,' -edit'
      :EndIf
    ∇

    ∇ r←FindDependencies Arg;folder;detailed;pkgList;buff;bool
      r←'Cancelled by user'
      detailed←Arg.detailed
      buff←Arg.(_1 _2)
      :If ∨/bool←∨/¨buff∊¨'.' './'
          (bool/buff)←1⍴1 ⎕NPARTS'./'
      :EndIf
      buff←{w←⍵ ⋄ w[⍋∨/¨'/\'∘∊¨w]}buff
      pkgList←','(≠⊆⊢)1⊃buff
      folder←2⊃buff
      'Invalid package definition'Assert 0∧.=(⎕NS''){⊃∘⍺.⎕NC¨{'_'@(⍸⍵∊'.-')⊣⍵}¨⍵}pkgList
      r←⍪detailed TC.FindDependencies folder(⊃{⍺,',',⍵}/pkgList)
    ∇

    ∇ r←DeprecatePackage Arg;id;force;uri;packageID;versions;msg;rc;comment
      r←''
      id←Arg._1
      'You must specify a Tatin Registry and a package ID'Assert 0<≢id
      force←Arg.force
      comment←Arg._2
      id←TC.ReplaceRegistryAlias id
      'Tatin Registry not found'Assert 0<≢id
      (uri packageID)←TC.Reg.SeparateUriAndPackageID id
      'You must specify a package ID'Assert 0<≢packageID
      'You must specify at least a group and a name'Assert 1≤'-'+.=id
      packageID←TC.Reg.RemoveMinorAndPatch packageID
      versions←TC.ListVersions uri,TC.Reg.RemoveVersionNumber packageID
      :If 0=≢versions
          r←'Package not found'
      :Else
          versions←∪↓TC.Reg.RemoveMinorAndPatch¨versions
          :If 1='-'+.=packageID
          :AndIf 1<≢versions
              :If force
                  msg←'These major versions were found for ',packageID,' on ',uri,':',CR
                  msg,←⊃,/(⊂'  '),¨versions,¨CR
                  msg,←'Are you sure that you want to deprecate ALL these versions?'
              :OrIf TC.YesOrNo msg
                  (rc msg)←TC.DeprecatePackage uri comment packageID
                  :If 0=rc
                      r←'Successfully deprecated: ',packageID,' on ',uri,CR
                  :Else
                      r←'Deprecating ',packageID,' on ',uri,' failed; ',msg,CR
                  :EndIf
              :Else
                  r←'Cancelled by user'
                  :Return
              :EndIf
          :Else
              :If force
              :OrIf TC.YesOrNo'Sure that you want to deprecate <',packageID,'> on ',uri,' ?'
                  (rc msg)←TC.DeprecatePackage uri comment packageID
                  :If 0=rc
                      r←'Successfully deprecated: ',packageID,' on ',uri
                  :Else
                      r←'Deprecating ',packageID,' on ',uri,' failed: ',msg
                  :EndIf
              :EndIf
          :EndIf
      :EndIf
    ∇

    ∇ {r}←UpdateTatin Arg;path;filename;folder;path2Config;version;ref;target
      folder←1⊃⎕NPARTS ##.SourceFile
      (version ref target)←⎕SE._Tatin.Client.UpdateClient 0 folder
      :If 0<≢version
          ⎕SE._Tatin.APLTreeUtils2.GoToWebPage ⎕SE._Tatin.Client.GetMyUCMDsFolder'Tatin/Assets/docs/ReleaseNotes.html'
          r←'Tatin updated on disk to ',⊃{⍺,' from ',⍵}/1↓⎕SE.Tatin.Version
          r,←(⎕UCS 13),'The current WS has NOT been updated, please restart a fresh session.'
      :EndIf
    ∇

    ∇ r←ListPackages Arg;registry;parms;buff;qdmx;OSs
      r←''
      registry←Arg._1
      :If 0≡registry
          registry←tatinURL
      :ElseIf (,'?')≡,registry
          →(⍬≡registry←SelectRegistry 0)/0
      :EndIf
      registry←EnforceSlash registry
      parms←⎕NS''
      :If 0≢Arg.group
          parms.group←Arg.group
      :EndIf
      :If 0≢Arg.tags
          parms.tags←Arg.tags
      :EndIf
      :If 0≢Arg.noaggr
          parms.aggregate←~Arg.noaggr
      :EndIf
      parms.date←Arg.date
      :If 0≢Arg.since
          :If '-'∊Arg.since
              parms.since←⊃(//)⎕VFI Arg.since~'-'
          :Else
              parms.since←(4↑Arg.since),'-',(2↑4↓Arg.since),'-',2↑6↓Arg.since
          :EndIf
      :EndIf
      :If 0≢Arg.os
          OSs←⎕C','(≠⊆⊢)Arg.os
          'Only "lin", "mac" and "win" are valid options for -os='Assert∧/OSs∊'win' 'lin' 'mac'
          parms.os_lin←(⊂'lin')∊OSs
          parms.os_mac←(⊂'mac')∊OSs
          parms.os_win←(⊂'win')∊OSs
      :EndIf
      parms.project_url←Arg.project_url
      :Trap ErrNo
          r←⍪parms TC.ListPackages registry
      :Else
          qdmx←⎕DMX
          CheckForInvalidVersion qdmx
      :EndTrap
      :If 0=≢r
          r←'No packages found'
      :Else
          :If TC.IsInstallFolder registry
              r[;2]←' *'[1+r[;2]]
              r(AddHeader)←'Package-ID' 'Principal'
          :Else
              :If 0≡parms.date
                  r(AddHeader)←(2⊃⍴r)↑(⊂'Group & Name'),((parms.aggregate)/⊂'∑ major versions'),(⊂'Project URL')
              :Else
                  r(AddHeader)←(2⊃⍴r)↑'Group & Name' 'Published at' 'Project URL'
              :EndIf
              buff←{'['∊⍵:⍵↑⍨⍵⍳']' ⋄ ⊃TC.Reg.SeparateUriAndPackageID ⍵}registry
              r←((2⊃⍴r)↑(⊂'Registry: ',{⍵↓⍨-'/'=¯1↑⍵}buff),(2⊃⍴r)⍴⊂'')⍪r
          :EndIf
      :EndIf
    ∇

    ∇ r←ListDeprecated Arg;registry;buff;qdmx;⎕TRAP
      r←''
      registry←Arg._1
      :If 0≡registry
          registry←tatinURL
      :ElseIf (,'?')≡,registry
          →(⍬≡registry←SelectRegistry 0)/0
      :EndIf
      registry←EnforceSlash registry
      :Trap ErrNo
          r←⍪TC.ListDeprecated registry
      :Else
          qdmx←⎕DMX
          CheckForInvalidVersion qdmx
      :EndTrap
      :If 0=≢r
          r←'No deprecated packages found'
      :EndIf
    ∇

    ∇ r←LoadDependencies Arg;installFolder;f1;f2;targetSpace;saveIn;overwriteFlag
      installFolder←Arg._1
      :If 0≡Arg._2
          :If 0=≢targetSpace←DefineTargetSpace ⍬
              ⎕←'Cancelled by user'
              :Return
          :EndIf
      :Else
          targetSpace←,Arg._2
      :EndIf
      overwriteFlag←Arg.overwrite
      installFolder←'apl-dependencies.txt'{⍵↓⍨(-≢⍺)×⍺≡(-≢⍺)↑⍵}installFolder
      f1←TC.F.IsDir installFolder
      f2←(TC.F.IsFile installFolder)∧'.zip'≡⎕C ¯4↑installFolder
      '⍵[1] is neither a folder nor a ZIP file'Assert f1∨f2
      :If ~(⊂,1 ⎕C targetSpace)∊,¨'#' '⎕SE'
          '"targetSpace" is not a valid APL name'Assert ¯1≠⎕NC targetSpace
      :EndIf
      saveIn←⍎{⍵↑⍨¯1+⍵⍳'.'}targetSpace
      ({⍵↓⍨⍵⍳'.'}targetSpace)saveIn.⎕NS''
      :If 0=saveIn.⎕NC'targetSpace'
          ((1+≢saveIn)↓targetSpace)saveIn.⎕NS''
      :EndIf
      'Arg[2] must not be scripted'Assert IsScripted⍎targetSpace
      r←TC.LoadDependencies installFolder targetSpace overwriteFlag
      r←⍪r
    ∇

    ∇ r←CheckForLaterVersion Arg;path;question;this;b;flags;colHeaders;bool;buff;info1;info2;qdmx
      r←''
      path←Arg._1
      flags←(1×Arg.major)+(2×Arg.dependencies)
      :Trap ErrNo
          r←flags TC.CheckForLaterVersion path
      :Else
          qdmx←⎕DMX
          CheckForInvalidVersion qdmx
      :EndTrap
      :If 0<≢r
          colHeaders←'Installed' 'Latest' 'Original URL' 'I' 'New URL'
          r←colHeaders⍪' '⍪r
          r[2;]←(⌈⌿≢¨r)⍴¨'-'
          b←1≡¨r[;4]
          r[⍸b;4]←'!'
          r[2↓⍸~b;4]←⊂''
          info1←info2←''
          :If '!'∊r[;4]
              info1←'! = Check version available'
          :EndIf
          :If ∨/bool←0={⍵[;4]}buff←(1 TC.ListRegistries'')
              info2←'Not scanned because priority is zero: ',⊃{⍺,', ',⍵}/∪bool/buff[;1]
          :EndIf
          r←⍪↓⎕FMT r
          :If 0<≢info1,info2
              r⍪←⊂' '
              :If 0<≢info1
                  r⍪←⊂info1
              :EndIf
              :If 0<≢info2
                  r⍪←⊂info2
              :EndIf
          :EndIf
      :EndIf
    ∇

    ∇ r←UsageData Arg;registry;list;ind;list2;b;qdmx
      r←''
      :If 0≡registry←Arg._1
          →(⍬≡registry←SelectRegistry 0)/0
      :EndIf
      :If 0≡Arg.download
      :AndIf 0∊b←0≡¨Arg.(all folder unzip)
          ('These options were ignored because -download was not specified: ',⊃{⍺,' ',⍵}/(~b)/'-all' '-folder=' '-unzip')Assert 0=+/b
          :Trap ErrNo
              r←TC.UsageDataGetList registry
          :Else
              qdmx←⎕DMX
              CheckForInvalidVersion qdmx
          :EndTrap
      :Else
          :Trap ErrNo
              list←TC.UsageDataGetList registry
          :Else
              qdmx←⎕DMX
              CheckForInvalidVersion qdmx
          :EndTrap
          :If 0≡Arg.download
              r←list
          :Else
              r←''
              :If 0<≢list  ⍝ Yes, can happen: if in the very first month there are no downloads at all
                  :If 0≡Arg.all
                      ind←'Please select the file(s) you wish to download:' 1 0 TC.C.Select list
                      →(0=ind)/0
                  :Else
                      ind←⍳≢list
                  :EndIf
                  :If 0≡Arg.folder
                      r←TC.UsageDataGetFiles registry(list[ind])
                  :Else
                      r←Arg.folder TC.UsageDataGetFiles registry(list[ind])
                  :EndIf
                  :If 0≢Arg.unzip
                      list2←(⊂r,'/'),¨list[ind]
                  :AndIf ∧/⎕NEXISTS¨list2
                      TC.F.DeleteFile(¯3↓¨list2),¨⊂'csv'
                      r∘{⍵ TC.ZipArchive.UnzipTo ⍺}¨list2
                      TC.F.DeleteFile TC.F.ListFiles r,'/*.zip'
                  :EndIf
              :EndIf
          :EndIf
      :EndIf
    ∇

    ∇ r←ReInstallDependencies Args;installFolder;registry;refs;deps;msg;parms;qdmx
      r←''
      'Mandatory argument (install directory) must not be empty'Assert 0<≢installFolder←Args._1
      :If 0≡Args._2
          registry←''
      :Else
          registry←Args._2
      :EndIf
      parms←TC.CreateReInstallParms
      parms.dry←0 Args.Switch'dry'
      parms.force←0 Args.Switch'force'
      parms.noBetas←0 Args.Switch'nobetas'
      parms.update←1 Args.Switch'update'
      installFolder←{0≡⍵:'' ⋄ ⍵}installFolder
      installFolder←'apl-dependencies.txt'{⍵↓⍨(-≢⍺)×⍺≡⎕C(-≢⍺)↑⍵}installFolder
      :If 0=≢installFolder←EstablishPackageFolder installFolder
          :Return
      :EndIf
      ('Is not a directory: ',installFolder)Assert TC.F.IsDir installFolder
      :If ~Args.force
          :If 0=TC.C.YesOrNo'Sure you want act on <',installFolder,'> ?'
              :Return
          :EndIf
      :EndIf
      'Directory does not host a file apl-dependencies.txt'Assert TC.F.IsFile installFolder,'/apl-dependencies.txt'
      deps←⊃TC.F.NGET(installFolder,'/apl-dependencies.txt')1
      'Dependency file is empty'Assert 0<≢deps
      :If parms.force
      :OrIf TC.C.YesOrNo'Re-install ',(⍕≢deps),' Tatin packages in ',installFolder,'?'
          :Trap ErrNo
              r←parms TC.ReInstallDependencies installFolder registry
          :Else
              qdmx←⎕DMX
              CheckForInvalidVersion qdmx
          :EndTrap
          :If ~parms.force
              ⎕←'*** Done'
          :EndIf
      :EndIf
    ∇

    ∇ msg←DeletePackage Arg;path;msg;statusCode;qdmx
      path←Arg._1
      :Trap ErrNo
          (statusCode msg)←TC.DeletePackage path
      :Else
          qdmx←⎕DMX
          CheckForInvalidVersion qdmx
      :EndTrap
      :If 200=statusCode
          msg←'Package was successfully deleted'
      :EndIf
     ⍝Done
    ∇

    ∇ r←GetDeletePolicy Arg;uri;qdmx;check
      r←⍬
      uri←Arg._1
      :If 0≡Arg._1
          →(⍬≡uri←SelectRegistry 0)/0
      :EndIf
      :Trap ErrNo
          check←0 Arg.Switch'check'
          r←check TC.GetDeletePolicy uri
      :Else
          qdmx←⎕DMX
          CheckForInvalidVersion qdmx
      :EndTrap
    ∇

    ∇ zipFilename←BuildPackage Arg;filename;sourcePath;targetPath;prompt;msg;dependencies;version
      (sourcePath targetPath)←Arg.(_1 _2)
      prompt←0
      zipFilename←''
      :If 0≡sourcePath
      :OrIf (,'.')≡,sourcePath
      :OrIf 0=≢sourcePath
          sourcePath←TC.F.PWD
          prompt∨←1
      :EndIf
      :If 0≡targetPath
      :OrIf (,'.')≡,targetPath
      :OrIf 0=≢targetPath
          targetPath←sourcePath
          prompt∨←1
      :EndIf
      dependencies←''Arg.Switch'dependencies'
      version←''Arg.Switch'version'
      :If '+'=1⍴version
          'A rule for "version" must have two dots and just 0 and 1'Assert 2+.='.'=1↓version
          'A rule for "version" must have two dots and just 0 and 1'Assert∧/('.'~⍨1↓version)∊'01'
      :EndIf
      (sourcePath targetPath)←AddSlash¨sourcePath targetPath
      'Source path (⍵[1]) is not a directory'Assert TC.F.IsDir sourcePath
      filename←sourcePath,TC.CFG_Name
      ('Could not find a file "',TC.CFG_Name,'" in ',sourcePath)Assert TC.F.IsFile filename
      :If ~(1↑targetPath)∊'/\'
      :AndIf (1↑1↓targetPath)≠':'
          targetPath←sourcePath,targetPath
      :EndIf
      (sourcePath targetPath)←{⊃1 ⎕NPARTS ⍵,'/'}¨sourcePath targetPath
      :If prompt
          msg←'Sure that you want to pack ',sourcePath,' into '
          :If sourcePath≡targetPath
              msg,←'the same directory?'
          :Else
              msg,←targetPath,'?'
          :EndIf
      :AndIf 0=1 TC.C.YesOrNo msg
          ⎕←'Cancelled by user'
          :Return
      :EndIf
      :If 0=⎕NEXISTS targetPath
      :AndIf 1 TC.C.YesOrNo'Target directory does not exist yet; create it?'
          TC.F.MkDir targetPath
      :EndIf
      'Target path (⍵[2]) is not a directory'Assert TC.F.IsDir targetPath
      zipFilename←dependencies TC.BuildPackage sourcePath targetPath version
    ∇

    ∇ r←PublishPackage Arg;url;url_;qdmx;statusCode;list;source;msg;rc;zipFilename;firstFlag;packageID;policy;f1;f2;dependencies
      r←''
      (source url)←Arg.(_1 _2)
      :If (,'?')≡,url
          :If 0=≢url←SelectRegistry 1
              :Return
          :Else
              url←'[',url,']'
          :EndIf
      :EndIf
      url_←TC.ReplaceRegistryAlias url
      :If ~TC.Reg.IsHTTP url_
      :AndIf ~TC.Reg.IsFILE url
          'Invalid target'Assert'['∊url
          url←'[',(url~'[]'),']'
      :EndIf
      ('"',url,'" is not a Registry')Assert 0<≢url_
      :If TC.F.IsDir source
          ('"',source,'" does not contain a Tatin package')Assert TC.F.IsFile source,'/',TC.CFG_Name
      :Else
          ('"',source,'" is not a ZIP file')Assert'.zip'≡⎕C ¯4↑source
      :EndIf
      firstFlag←1
      :Trap ErrNo
          f1←'none'≡⎕C policy←TC.GetDeletePolicy url_
      :Else
          qdmx←⎕DMX
          CheckForInvalidVersion qdmx
      :EndTrap
      ⍝ From now on we can be confident that the version of the server is in line with the client
      :If f2←'justbetas'≡⎕C policy←TC.GetDeletePolicy url_
          f2←~TC.Reg.IsBeta url_
      :EndIf
      :If f1∨f2
          msg←'Attention - the server:'
          msg,←CR,'>>> ',url_,' <<<'
          msg,←CR,'operates a "',policy,'" delete policy.'
          :If f2
              msg,←CR,'The package is not e beta release.'
          :EndIf
          msg,←CR,'Are you sure that you want to publish anyway?'
          :If 0=TC.C.YesOrNo msg
              ⎕←'Publishing cancelled'
              :Return
          :EndIf
      :EndIf
      dependencies←''Arg.Switch'dependencies'
     ∆Again:
      :Trap ErrNo
          :If 0<≢dependencies
              (rc msg zipFilename)←dependencies TC.PublishPackage source url
          :Else
              (rc msg zipFilename)←TC.PublishPackage source url
          :EndIf
          :If 200≡rc
              r←'Package published on ',url_
          :Else
              r←msg,'; RC=',⍕rc
          :EndIf
      :Else
          qdmx←⎕DMX
          :If 'HTTP status code:'{⍺≡(≢⍺)↑⍵}qdmx.EM
              statusCode←⊃⊃(//)⎕VFI ¯3↑qdmx.EM
              :Select statusCode
              :Case 400
                  r←'Bad request'
              :Case 401
                  r←'Your are not authorized to publish at ',url_
              :Case 500
                  r←'The server ',url_,' reported an internal error'
              :Else
                  qdmx.EM ⎕SIGNAL ErrNo
              :EndSelect
          :Else
              :If firstFlag
              :AndIf 'Server: The package has already been published'{⍺≡(≢⍺)↑⍵}qdmx.EM
              :AndIf 'Any'≡⎕SE.Tatin.GetDeletePolicy url_
                  packageID←2⊃⎕NPARTS source
              :AndIf TC.C.YesOrNo packageID,' already published on ',url_,'; overwrite?'
                  firstFlag←0
                  (rc msg)←⎕SE.Tatin.DeletePackage url,packageID
                  :If 200=rc
                      →∆Again
                  :Else
                      ⎕←'Delete attempt failed with status ',(⍕rc),'; publishing therefore not possible'
                      :Return
                  :EndIf
              :EndIf
              :If ∨/'<title>'⍷qdmx.EM
                  r←GetTitleFromHtml qdmx.EM
              :ElseIf 0<≢r←qdmx.EM
                  r←qdmx.EM
              :EndIf
          :EndIf
      :EndTrap
    ∇

    ∇ r←UnInstallPackage Arg;path;packageID;msg;list;ind
    ⍝ Attempt to un-install the top-level package `packageID` from the folder `path`
      r←''
      :If Arg.cleanup
          'You must not specify more than one argument together with the -cleanup flag'Assert 0≡Arg._2
          packageID←''
          path←Arg._1
      :Else
          (packageID path)←Arg.(_1 _2)
          'You mast specify <packageID> and <installFolder>'Assert∧/0≢¨packageID path
          'No package specified'Assert 0≢packageID
      :EndIf
      :If './'≢2⍴path
      :AndIf '/'≠1⍴path
      :AndIf ~':'∊path
          :If '['=1⍴path
          :AndIf ']'∊path
              path←TranslateCiderAlias path
          :Else
              :If 0=≢path←Arg.quiet EstablishPackageFolder path
                  :Return
              :EndIf
              ('Does not exist: ',path)Assert TC.F.IsDir path
              :If 0=TC.C.YesOrNo'Sure that you want act on: ',path,' ?'
                  :Return
              :EndIf
          :EndIf
      :EndIf
      (r msg)←TC.UnInstallPackage packageID path
      msg Assert 0=≢msg
    ∇

    ∇ r←ListRegistries Arg;type
      type←0
      :If 0≢Arg.Switch'full'
          type←Arg.Switch'full'
      :EndIf
      r←TC.ListRegistries type
      r←((,[0.5]'URI' 'Alias' 'Port' 'Priority',(1≡type)/⊂'API-key'),[1]' ')⍪r
      r[2;]←(⌈⌿≢¨r)⍴¨'-'
    ∇

    ∇ {r}←Init Arg
      :If 0≡Arg._1
          r←TC.Init''
      :Else
          r←TC.Init Arg._1
      :EndIf
    ∇

    ∇ r←ListTags Arg;parms;registry;qdmx;buff
      r←''
      parms←⎕NS''
      parms.tags←''
      registry←Arg._1
      :If 0≡registry
          registry←tatinURL
      :ElseIf (,'?')≡,registry
          →(⍬≡registry←SelectRegistry 0)/0
      :Else
          registry,←(~(¯1↑registry)∊'/\')/'/'
      :EndIf
      :If 0≢Arg.tags
      :AndIf 0<≢Arg.tags
          parms.tags←Arg.tags
      :EndIf
      :If 0≢Arg.os
      :AndIf 0<≢Arg.os
          buff←⎕C','(≠⊆⊢)Arg.os
          'Only "lin", "mac" and "win" are valid for -os='Assert∧/buff∊'lin' 'mac' 'win'
          parms.(os_lin os_mac os_win)←'lin' 'mac' 'win'∊','(≠⊆⊢)Arg.os
      :EndIf
      :Trap ErrNo
          :If 0<≢buff←parms TC.ListTags registry
              r←⍪({⍵((≢⍵)⍴'-')}'All tags from ',registry),{⍵[;1]}buff
          :Else
              r←'No tags found'
          :EndIf
      :Else
          qdmx←⎕DMX
          CheckForInvalidVersion qdmx
      :EndTrap
    ∇

    ∇ r←ListVersions Arg;qdmx;dateFlag;buff;caption;ind;arg
      dateFlag←Arg.Switch'date'
      arg←Arg._1
      :Trap ErrNo
          :If '[?]'{⍺≡(≢⍺)↑⍵}arg
              'No package specified'Assert 0<≢{⍵↓⍨⌈/⍵⍳'?]'}arg
              buff←{⍵[;1 2]}TC.ListRegistries 0
              ind←'Please select a Registry:'TC.C.Select↓⎕FMT buff
              :If 0=≢ind
                  r←'Cancelled by user'
                  :Return
              :Else
                  arg←(1⊃buff[ind;]),{⍵↓⍨⌈/⍵⍳'?]'}arg
              :EndIf
          :EndIf
          :If dateFlag
              r←dateFlag TC.ListVersions arg
              r[;2⊃⍴r]←TC.Reg.FormatFloatDate¨r[;2⊃⍴r]
              r←⊃,/CR,¨↓⍕r
              r←(1↓⊃,/CR,¨↓('All versions of <',arg,'> :'),[0.5]'-'),r
          :Else
              buff←TC.ListVersions arg
              :If 0=≢buff
                  r←'Not found: <',arg,'>'
              :ElseIf TC.Reg.IsHTTP TC.ReplaceRegistryAlias arg
                  caption←1 2⍴('*** All versions of package <',arg,'> :')' '
                  caption⍪←('-'⍴⍨≢1⊃caption[1;])''
                  buff[;1]←' ',¨buff[;1]
                  r←caption⍪buff,' '
              :Else
                  :If 2=2⊃⍴buff
                      r←⍪(↓⎕FMT 2↑('All versions of <',arg,'> :'),[0.5]'-'),↓⎕FMT' ',¨buff
                  :Else
                      r←(⍪↓('All versions of <',arg,'> :'),[0.5]'-')⍪' ',¨buff
                  :EndIf
              :EndIf
          :EndIf
      :Else
          qdmx←⎕DMX
          CheckForInvalidVersion qdmx
          :If 0=≢qdmx.EM
              ('Not found: ',arg)⎕SIGNAL ErrNo
          :Else
              qdmx.EM ⎕SIGNAL ErrNo
          :EndIf
      :EndTrap
    ∇

    ∇ r←Documentation Arg
      r←0 0⍴⍬
      {}⎕SE._Tatin.APLTreeUtils2.GoToWebPage tatinURL,'/v1/documentation'
    ∇

    ∇ r←LoadPackages Arg;targetSpace;identifier;saveIn;noOf;qdmx
      r←''
      (identifier targetSpace)←Arg.(_1 _2)
      :If 0≡targetSpace
      :AndIf 0=≢targetSpace←DefineTargetSpace ⍬
          ⎕←'Cancelled by user'
          :Return
      :EndIf
      :If ~(⊂,1 ⎕C targetSpace)∊,¨'#' '⎕SE'
          ('"',targetSpace,'" is not a valid APL name')Assert ¯1≠⎕NC targetSpace
      :EndIf
      saveIn←⍎{⍵↑⍨¯1+⍵⍳'.'}targetSpace
      :If ~(⊂1 ⎕C targetSpace)∊,¨'#' '⎕SE'
      :AndIf 0=saveIn.⎕NC'targetSpace'
          '"targetSpace" does not specify a fully qualified namespace in either # or ⎕SE'Assert'.'∊targetSpace
          ((1+≢saveIn)↓targetSpace)saveIn.⎕NS''
      :EndIf
      :Trap 0
          noOf←Arg.nobetas TC.LoadPackages identifier targetSpace
          r←(⍕noOf),' package',((1≠noOf)/'s'),' (including dependencies) loaded'
      :Else
          ⍝ We must make sure that all connections get closed before passing on the error
          qdmx←⎕DMX
          TC.CloseConnections 1
          CheckForInvalidVersion qdmx
      :EndTrap
    ∇

    ∇ r←PackageConfig Arg;path;ns;newFlag;origData;success;newData;msg;qdmx;filename;what;uri;list;flag;data;openCiderProjects;ind
      r←⍬
      :If (,0)≡,what←Arg._1
          :If 9=⎕SE.⎕NC'Cider'
              openCiderProjects←⎕SE.Cider.ListOpenProjects 0
              :If 1<≢openCiderProjects
                  ind←'Which Cider project would you like to act on?'TC.C.Select↓⎕FMT openCiderProjects
                  :If 0=≢ind
                      →0 ⋄ r←'Cancelled by user'
                  :Else
                      what←2⊃openCiderProjects[ind;]
                  :EndIf
              :ElseIf 1=≢openCiderProjects
                  what←2⊃openCiderProjects[1;]
              :Else
                  what←TC.F.PWD
                  :If TC.YesOrNo'Sure you want to deal with ',what,' ?'
                      →0 ⋄ r←'Cancelled by user'
                  :EndIf
              :EndIf
          :Else
              what←TC.F.PWD
              :If TC.YesOrNo'Sure you want to deal with ',what,' ?'
                  →0 ⋄ r←'Cancelled by user'
              :EndIf
          :EndIf
      :ElseIf '['∊what
          what←0 TC.CheckVersion what
          what←TC.ReplaceRegistryAlias what
      :EndIf
      :If TC.Reg.IsHTTP what
          :Trap ErrNo
              r←TC.ReadPackageConfigFile_ what
          :Else
              qdmx←⎕DMX
              CheckForInvalidVersion qdmx
          :EndTrap
      :Else
          path←what
          filename←'expand'TC.F.NormalizePath({⍵,(~(¯1↑⍵)∊'/\')/'/'}path),TC.CFG_Name
          :If Arg.delete
              'File not found'Assert TC.F.IsFile filename
              msg←'Sure you want to delete "',filename,'" ?'
              :If Arg.quiet
              :OrIf 0 TC.C.YesOrNo msg
                  TC.F.DeleteFile filename
              :EndIf
          :Else
              :If 0=TC.F.IsDir path
                  :If Arg.quiet
                  :OrIf TC.C.YesOrNo'The directory does not exist yet. Would you like to create it?'
                      'Could not create the directory'Assert TC.F.MkDir path
                  :Else
                      ⎕←'Cancelled'
                      :Return ⍝ Give up
                  :EndIf
              :EndIf
              :If TC.F.IsFile filename
                  ns←TC.ReadPackageConfigFile path
                  newFlag←0
              :Else
                  :If ~Arg.quiet
                  :AndIf 0=TC.C.YesOrNo'There is no file ',filename,' yet; would you like to create it?'
                      ⎕←'Cancelled'
                      :Return
                  :EndIf
                  ns←TC.InitPackageConfig ⍬
                  newFlag←1
              :EndIf
              :If Arg.edit∨newFlag
                  data←TC.Reg.JSON ns
                  data←TC.AddCommentToPackageConfig data
                  origData←data
                  :Repeat
                      (success newData)←(CheckPackageConfigFile EditJson)'PackageConfigFile'data path
                      flag←1
                      :If success
                          :If 0<≢∊newData
                          :AndIf newFlag∨newData≢origData
                              ns←⎕JSON⍠('Dialect' 'JSON5')⊣newData
                              :Trap ErrNo
                                  1 TC.WritePackageConfigFile path ns
                              :Else
                                  qdmx←⎕DMX
                                  ⎕←qdmx.EM
                                  :If 0=1 TC.C.YesOrNo'Would you like to try to fix the problem in the editor? (n=abandon changes)'
                                      ⎕←'Cancelled, no change'
                                  :Else
                                      flag←0
                                      data←newData
                                  :EndIf
                              :EndTrap
                          :EndIf
                      :Else
                          ⎕←'No change, therefore no action is taken'
                      :EndIf
                  :Until flag
              :Else
                  r←⎕JSON⍠('Dialect' 'JSON5')('Compact' 0)⊣ns
              :EndIf
          :EndIf
      :EndIf
    ∇

    ∇ r←PackageDependencies Arg;path;newFlag;origData;success;newData;msg;temp;filename
      r←⍬
      path←Arg._1
      filename←path,'/apl-dependencies.txt'
      :If Arg.delete
          'File not found'Assert TC.F.IsFile filename
          msg←'Sure you want to delete the package dependency file in "',filename,'" ?'
          :If Arg.quiet
          :OrIf 0 TC.C.YesOrNo msg
              TC.F.DeleteFile filename
          :EndIf
      :ElseIf Arg.edit
          'Path does not exist'Assert TC.F.IsDir path
          temp←⎕NS'EditText'
          :If TC.F.IsFile filename
              origData←1⊃TC.F.NGET filename 1
              newFlag←0
          :Else
              origData←,⊂''
              newFlag←1
          :EndIf
          (success newData)←(CheckDependencies EditText)'PackageDependencies'origData
          :If 0<≢∊newData
          :AndIf newFlag∨newData≢origData
              (⊂newData)TC.F.NPUT filename 1
          :EndIf
      :Else
          'File not found'Assert TC.F.IsFile filename
          r←⊃TC.F.NGET filename
      :EndIf
    ∇

    ∇ r←InstallPackages Arg;identifier;installFolder;qdmx;list;ind;openCiderProjects;project;cfg;folders
      r←''
      (identifier installFolder)←Arg.(_1 _2)
      :If 0≡installFolder
          :If 0=Arg.quiet
              :If 9=⎕SE.⎕NC'Cider'
                  openCiderProjects←⎕SE.Cider.ListOpenProjects 0
                  :If 1<≢openCiderProjects
                      ind←'Which Cider project would you like to act on?'TC.C.Select↓⎕FMT openCiderProjects
                      :If 0=≢ind
                          →0 ⋄ r←'Cancelled by user'
                      :Else
                          project←2⊃openCiderProjects[ind;]
                      :EndIf
                  :ElseIf 1=≢openCiderProjects
                      project←2⊃openCiderProjects[1;]
                  :Else
                      →0 ⋄ r←'No path specified & no open Cider projects found'
                  :EndIf
                  ('No Cider config file found in ',project)Assert ⎕NEXISTS project,'/cider.config'
                  cfg←TC.Reg.GetJsonFromFile project,'/cider.config'
                  'In the Cider config file "tatinFolder" is empty'Assert 0<≢cfg.CIDER.tatinFolder
                  folders←{1⊃'='(≠⊆⊢)⍵}¨','(≠⊆⊢)cfg.CIDER.tatinFolder
                  :If 1<≢folders
                      ind←'Which folder would you like to install packages into?'TC.C.Select(⊂project,'/'),¨folders
                      :If 0=≢ind
                          →0 ⋄ r←'Cancelled by user'
                      :Else
                          installFolder←project,'/',ind⊃folders
                      :EndIf
                  :ElseIf 1=≢folders
                      installFolder←project,'/',1⊃folders
                  :EndIf
              :EndIf
          :EndIf
      :EndIf
      'Install folder is invalid'Assert~(⊂,1 ⎕C installFolder)∊,¨'#' '⎕SE'
      :If '[myucmds]'≡⎕C installFolder
          installFolder←⎕SE._Tatin.Client.GetMyUCMDsFolder''
      :ElseIf './'≢2⍴installFolder
      :AndIf '/'≠1⍴installFolder
      :AndIf ~':'∊installFolder
          :If '['=1⍴installFolder
          :AndIf ']'∊installFolder
              installFolder←TranslateCiderAlias installFolder
              'Cancelled by user'Assert 0<≢installFolder
          :Else
              :If 0=≢installFolder←EstablishPackageFolder{0≡⍵:'' ⋄ ⍵}installFolder
                  :Return
              :EndIf
              :If 0=TC.C.YesOrNo'Sure that you want act on: ',installFolder,' ?'
                  :Return
              :EndIf
          :EndIf
      :EndIf
      :If ~TC.F.IsDir installFolder
          :If Arg.quiet
          :OrIf 1 TC.C.YesOrNo'Install folder <',installFolder,'> does not yet exist; create?'
              'Create!'TC.F.CheckPath installFolder
          :EndIf
      :EndIf
      ('Does not exist: ',installFolder)Assert ⎕NEXISTS installFolder
      :Trap 0
          r←TC.InstallPackages identifier installFolder
      :Else
          ⍝ We must make sure that all connections get closed before passing on the error
          qdmx←⎕DMX
          TC.CloseConnections 1
          CheckForInvalidVersion qdmx
      :EndTrap
    ∇

    ∇ installFolder←TranslateCiderAlias installFolder;ind;alias;list;cfgFilename;cfg;folders
      'Cider is not available'Assert 9=⎕SE.⎕NC'Cider'
      ind←installFolder⍳']'
      alias←(ind↑installFolder)~'[]'
      installFolder←ind↓installFolder
      list←⎕SE.Cider.GetAliasFileContent
      'No Cider projects found'Assert 0<≢list
      ('Alias "',alias,'" does not define an open Cider project')Assert(⊂⎕C alias)∊list[;1]
      :If 0<≢installFolder
          installFolder←(AddSlash 2⊃list[list[;1]⍳⊂⎕C alias;]),installFolder
      :Else
          cfgFilename←(AddSlash 2⊃list[list[;1]⍳⊂⎕C alias;]),'cider.config'
          ('No Cider config file found in ',cfgFilename)Assert ⎕NEXISTS cfgFilename
          cfg←⎕JSON⍠('Dialect' 'JSON5')⊣⊃⎕NGET cfgFilename
          folders←{⍵↑⍨¯1+⍵⍳'='}¨','(≠⊆⊢)cfg.CIDER.tatinFolder
          'No Tatin folder defined in the Cider config file'Assert 0<≢folders
          :If 1=≢folders
              installFolder←(AddSlash 2⊃list[list[;4]⍳⊂⎕C alias;]),⊃folders
          :Else
              ind←('Select package install folder for ',alias,':')TC.C.Select folders
              :If 0=≢ind
                  installFolder←''
              :Else
                  installFolder←(AddSlash 2⊃list[list[;4]⍳⊂⎕C alias;]),ind⊃folders
              :EndIf
          :EndIf
      :EndIf
    ∇

    ∇ r←UserSettings Arg;origData;filename;ns;new;buff
      r←''
      filename←TC.F.NormalizePath TC.MyUserSettings.path2config
      ('User setting file "',filename,'" does not exist?!')Assert ⎕NEXISTS filename
      origData←1⊃⎕NGET filename
      :If Arg.edit
          :If 0=≢new←EditJSON origData
              ⎕←'Cancelled without a change'
          :Else
              :If new≢origData
              :AndIf 1 TC.C.YesOrNo'Do you want to save your changes to disk?'
                  (⊂new)⎕NPUT filename 1
              :AndIf 1 TC.C.YesOrNo'Saved! Would you like to refresh the user settings in ⎕SE?'
                  TC.Init ⍬
                  ⎕←'User settings in ⎕SE updated'
              :EndIf
          :EndIf
      :ElseIf Arg.refresh
          r←TC.Init ⍬
      :Else
          :If ~Arg.apikey
              origData←'api_key["]*: "[^"]+'⎕R'api_key: "***'⊣origData          ⍝ Replace API key by Asterisks
          :EndIf
          buff←(⎕UCS 10)(≠⊆⊢)origData
          buff←(';'≠⊃¨buff)⌿buff
          r←⍪(⊂'User settings in <',filename,'> :'),buff
      :EndIf
    ∇

    ∇ r←Ping Arg;registry;registries
      r←⍬
      registry←Arg._1
      :If 0≡registry   ⍝ No argument specified? We ping all we know about!
          r←0 2⍴⍬
          :If 0<≢registries←GetListOfRegistriesForSelection 0
          :AndIf 0<≢registries←(TC.Reg.IsHTTP¨registries[;1])⌿registries
          :AndIf 0<≢registries←registries[∪{⍵⍳⍵}registries[;1];] ⍝ Because the same URL might turn up multiple times with different credentials/alias
              ⎕←'Questioning ',(⍕≢registries),' Tatin Registr',((1+1=≢registries)⊃'ies' 'y'),'...'
              r←{⍵,[1.5]⎕TSYNC{TC.Ping ⍵}¨&⍵}registries[;1]
          :EndIf
      :ElseIf (,'?')≡,registry
          :If 0=≢registries←1 SelectRegistry 0
              :Return
          :EndIf
          :If 0≠≢registries
              ⎕←'Questioning ',(⍕≢registries),' Tatin Registr',((1+1=≢registries)⊃'ies' 'y'),'...'
              r←{⍵,[1.5]⎕TSYNC{TC.Ping ⍵}¨&⍵}registries
          :EndIf
      :Else
          ⎕←'Questioning 1 Tatin Registry...'
          r←⍉⍪TC.Ping registry
      :EndIf
    ∇

    ∇ r←Cache Arg;url;list;pathFlag;flag;report;rc
      r←''
      :If 0≡Arg._1
          url←''
      :Else
          url←Arg._1
      :EndIf
      :If Arg.path
      :OrIf Arg.clear
          pathFlag←1
      :Else
          pathFlag←0
      :EndIf
      :If 0<≢list←pathFlag TC.ListCache url
          :If Arg.clear
              r←⎕FMT⍪{⍪('--- Entries in cache for ',(1⊃⍵),':')(⍪2⊃⍵)}¨list
          :Else
              r←⎕FMT⍪{⍪('--- Entries in cache for ',(1⊃⍵),':')(⍪2⊃⍵)}¨list
          :EndIf
      :Else
          r←'*** Nothing found'
      :EndIf
      :If 0<≢list
      :AndIf Arg.clear
          :If Arg.force
              flag←1
          :Else
              ⎕←r
              flag←TC.C.YesOrNo'*** Sure that you want delete these from the Tatin package cache?'
          :EndIf
      :AndIf flag
          (rc report)←TC.ClearCache url
          :If 0=rc
              r←'*** Cache successfully cleared'
          :Else
              r←'*** Attempt to delete these failed:',⊃,/(⎕UCS 10)¨,⊆report
          :EndIf
      :EndIf
    ∇

    ∇ (success newData)←(CheckFns EditJson)(name origData path);temp;msg;flag;json
    ⍝ Operator that allows the user to edit `origData` which is supposed to be JSON.\\
    ⍝ After editing it the function checks whether it is still valid JSON.
    ⍝ The user must either fix any problems or make sure that the JSON is empty,
    ⍝ in which case no action is taken
      temp←⎕SE.⎕NS''
      temp.⎕FX ⎕CR'ED'
      ⍎'temp.',name,'←origData'
      flag←1
      success←0
      newData←''
      :Repeat
          temp.ED name
          :If origData≢temp.⍎name
              json←temp.⍎name
          :AndIf 0<≢(∊json)~' '
              :If ~success←IsValidJSON json
                  msg←'This is not valid JSON; do you want to fix the problem? N=abandon changes'
                  flag←~TC.C.YesOrNo msg
              :Else
                  (msg json)←CheckFns json path
                  :If 0<≢msg
                      :If ' did not respond'{⍺≡(-≢⍺)↑⍵}msg
                          :If TC.C.YesOrNo msg,'; edit again (N=accept the URL as it is) ?'
                              flag←0
                          :Else
                              newData←json
                              flag←1
                          :EndIf
                      :Else
                          flag←~1 TC.C.YesOrNo msg,CR,'Want to try fixing the problem (n=abandon ALL changes) ?'
                      :EndIf
                  :Else
                      flag←1
                      newData←json
                  :EndIf
              :EndIf
          :Else
              flag←1
          :EndIf
      :Until flag
    ∇

    ∇ (success newData)←(CheckFns EditText)(name origData);temp;msg;flag;txt
    ⍝ Operator that allows the user to edit `origData`. The function `CheckFns` is supposes to either
    ⍝ return an empty char vector (interpret3d as "okay") or an error message.\\
    ⍝ If you don't want to perform a check specify `{''}` as left operand.\\
    ⍝ The user must either fix any problems or make sure that the text is empty,
    ⍝ in which case no action is taken
      temp←⎕SE.⎕NS''
      temp.⎕FX ⎕CR'ED'
      ⍎'temp.',name,'←origData'
      flag←1
      success←0
      newData←''
      :Repeat
          temp.ED name
          :If origData≢temp.⍎name
              txt←⊆temp.⍎name
              txt←(0<≢¨txt)/txt
              txt{TC.A.(DLB DTB)⍵}¨txt
          :AndIf 0<≢(∊txt)~' '
              :If 0<≢msg←CheckFns txt
                  ⎕←msg
                  flag←~TC.C.YesOrNo'Woulde you like to fix the problem? (N=abandon changes)'
              :Else
                  flag←1
                  newData←txt
              :EndIf
          :EndIf
      :Until flag
    ∇

    ∇ r←level Help Cmd;TC
      r←''
      :If 0=⎕SE.⎕NC'_Tatin'
          ⎕SE.UCMD'Tatin.LoadTatin'
      :EndIf
      TC←⎕SE._Tatin.Client
      :Select level
      :Case 0
          :Select ⎕C Cmd
          :Case ⎕C'BuildPackage'
              r,←⊂'Create a new version of a package (resulting in a ZIP) from the directory.'
              r,←'' '  ]Tatin.BuildPackage [<package-folder>] [<target-folder>] -dependencies= -version='
          :Case ⎕C'CreatePackage'
              r,←⊂'Create a new Tatin package with a given folder.'
              r,←'' '  ]Tatin.CreatePackage'
          :Case ⎕C'DeprecatePackage'
              r,←⊂'Declare packages as deprecated.'
              r,←'' '  ]Tatin.DeprecatePackage <URL|[Alias><group><name>[<major-version>] <comment> [-force]'
          :Case ⎕C'FindDependencies'
              r,←⊂'Attempts to find all folder(s) with the given Tatin package(s)'
              r,←'' '  ]Tatin.FindDependencies <folder> <comma-separated list of pkgs> -detailed'
          :Case ⎕C'LoadTatin'
              r,←⊂'Load the Tatin client into ⎕SE (if it''s not already there) and initializes it.'
              r,←'' '  ]Tatin.LoadTatin'
          :Case ⎕C'ListRegistries'
              r,←⊂'List URL, alias, priority and port of all Registries as defined in the user settings.'
              r,←'' '  ]Tatin.ListRegistries [-full]'
          :Case ⎕C'ListDeprecated'
              r,←⊂'List all deprecated major versions'
              r,←'' '  ]Tatin.ListDeprecated <URL|[Alias> [-all]'
          :Case ⎕C'ListPackages'
              r,←⊂'List all packages in the Registry or install folder passed as argument'
              r,←'' '  ]Tatin.ListPackages <URL|[Alias|<path/to/registry>|<install-folder>]> [-group=] [-tags=] [-os=] [-date] [-project_url] [-since={YYYYMMDD|YYYY-MM-DD}] [-noaggr]'
          :Case ⎕C'LoadPackages'
              r,←⊂'Load the specified package(s) and all dependencies into the workspace.'
              r,←'' '  ]Tatin.LoadPackages <packageIDs|package-URLs|Zip-file> [<target namespace>] -nobetas'
          :Case ⎕C'InstallPackages'
              r,←⊂'Install the given package(s) and all dependencies into the given folder.'
              r,←'' '  ]Tatin.InstallPackages <packageIDs|package-URLs|Zip-file> <install-path> [-quiet]'
          :Case ⎕C'LoadDependencies'
              r,←⊂'Load all packages defined in a file apl-dependencies.txt.'
              r,←'' '  ]Tatin.LoadDependencies <package-folder> [<parent-namespace>] [-overwrite]'
          :Case ⎕C'Maintenance'
              r,←⊂'Checks whether there are maintenance files available and asks the user about it'
              r,←'' '  ]Tatin.Maintenance path [-dry] [-show]'
          :Case ⎕C'UserSettings'
              r,←⊂'Print the usfer settings found in the config file to ⎕SE and allows manipulation via flags'
              r,←'' '  ]Tatin.UserSettings [-apikey] [-edit] [-refresh]'
          :Case ⎕C'PackageConfig'
              r,←⊂'Manage a package config file: fetch, create, edit or delete it.'
              r,←'' '  ]Tatin.PackageConfig <package-URL|package-folder> [-edit] [-delete]'
          :Case ⎕C'UnInstallPackage'
              r,←⊂'Uninstall a given package and possibly all its dependencies.'
              r,←'' '  ]Tatin.UnInstallPackage [<package-ID|package-alias>] <package-folder> -cleanup -quiet'
          :Case ⎕C'PackageDependencies'
              r,←⊂'Return the contents of a file "apl-dependencies.txt".'
              r,←'' '  ]Tatin.PackageDependencies <package-path> [-edit] [-delete] [-quiet]'
          :Case ⎕C'PublishPackage'
              r,←⊂'Publish a package to a particular Tatin Registry.'
              r,←'' '  ]Tatin.PublishPackage <package-folder|ZIP-file> <Registry-URL|[Registry-Alias]> -dependencies='
          :Case ⎕C'ListVersions'
              r,←⊂'List all versions of the given package of a given Registry or all Registries with a priority>0'
              r,←'' '  ]Tatin.ListVersions <[Registry-URL|[Registry-Alias][<group>]-<name>-[<version>] [-date]'
          :Case ⎕C'Version'
              r,←⊂'Print name, version number and version date of Tatin to the session.'
              r,←'' '  ]Tatin.Version [*] [-check] [-all]'
          :Case ⎕C'ListTags'
              r,←⊂'List all unique tags as defined in all packages on a Registry, sorted alphabetically.'
              r,←'' '  ]Tatin.ListTags [<Registry-URL>] [-tags=] [-os=]'
          :Case ⎕C'Init'
              r,←⊂'(Re-)Establish the user settings in ⎕SE.'
              r,←'' '  ]Tatin.Init [<config-folder>]'
          :Case ⎕C'CheckForLaterVersion'
              r,←⊂'Check whether for the installed packages a later versions are available.'
              r,←'' '  ]Tatin.CheckForLaterVersion <install-folder> [-major] [-dependencies]'
          :Case ⎕C'DeletePackage'
              r,←⊂'Delete a given package from a Tatin Registry.'
              r,←'' '  ]Tatin.DeletePackage <([Registry-alias|Registry-URL|file://package-folder)package-ID)>'
          :Case ⎕C'GetDeletePolicy'
              r,←⊂'Request which "Delete" policy is operated by a Registry.'
              r,←'' '  ]Tatin.GetDeletePolicy [<Registry-URL>] -check'
          :Case ⎕C'Documentation'
              r,←⊂'Put ',tatinURL,'/v1/documentation into the default browser'
              r,←'' '  ]Tatin.Documentation'
          :Case ⎕C'ReInstallDependencies'
              r,←⊂'ReInstall all packages installed in a folder from scratch.'
              r,←'' '  ]Tatin.ReInstallDependencies <install-folder> [Registry-URL|Registry-alias] [-force] [-dry] [-nobeta] [-update]'
          :Case ⎕C'Ping'
              r,←⊂'Try to contact the specified or all known Tatin Registries'
              r,←'' '  ]Tatin.Ping [Registry-URL]'
          :Case ⎕C'Cache'
              r,←⊂'List the contents of the Tatin package cache.'
              r,←'' '  ]Tatin.Cache [url] -path -clear -force'
          :Case ⎕C'UsageData'
              r,←⊂'Make package usage data available.'
              r,←'' '  ]Tatin.UsageData [Registry-alias|Registry-URL] -download -all -folder='
          :Case ⎕C'UpdateTatin'
              r,←⊂'Attempts to update the Tatin client and reports the result'
              r,←'' '  ]Tatin.UpdateTatin'
          :Else
              ∘∘∘ ⍝ New?!
          :EndSelect
          :If 'Version'≢Cmd
              r,←''(']Tatin.',Cmd,' -?? ⍝ Enter this for more information ')
          :EndIf
      :Case 1
          :Select ⎕C Cmd
          :Case ⎕C'BuildPackage'
              r,←⊂'Create a ZIP file from the directory ⍵[1] that is a package, and saves it in ⍵[2].'
              r,←⊂'Requires directory ⍵[1] to host a file "',TC.CFG_Name,'" defining the package.'
              r,←⊂'Note that calling this function will always increase the build number if there is one.'
              r,←⊂''
              r,←⊂' * If ⍵[2] is not specified the pack file will be created in ⍵[1], but the user will be prompted.'
              r,←⊂' * If ⍵[1] is not specified it will act on the current directory, but the user will be prompted.'
              r,←⊂''
              r,←⊂'-version=       Use this to set the version number in both the package project and the package'
              r,←⊂'                that is about to be created. You have several options:'
              r,←⊂'                * -version=+0.0.1 → bumps the patch number'
              r,←⊂'                * -version=+0.1.0 → bumps the minor number, and resets the patch number'
              r,←⊂'                * -version=+1.0.0 → bumps the major number, and resets patch & minor number'
              r,←⊂'                * -version=1.2.3-beta-2 assigns the given string to "version"'
              r,←⊂'                  It will preserve the build number and bump it'
              r,←⊂'                * -version=1.2.3-beta-2+123 will replace whatever is saved on "version", including'
              r,←⊂'                  the build number, which will still be bumped'
              r,←⊂''
              r,←⊂'-dependencies=  Use this to specify a subfolder of the project holding package dependencies.'
              r,←⊂'                Usually there is no need to specify this, refer to the documentation for details:'
              r,←⊂'                the document "Publishing Packages".'
          :Case ⎕C'CreatePackage'
              r,←⊂'Prints a user command to the session that allow creating a package config file, the'
              r,←⊂'equivalent of creating a package.'
          :Case ⎕C'DeprecatePackage'
              r,←⊂'Declare a particular major version of a package or all major versions of a particular'
              r,←⊂'package as deprecated. Requires two arguments:'
              r,←⊂''
              r,←⊂'1. Argument'
              r,←⊂' * If a package ID like "GroupName-PkgName-6 is specified as first argument then a new'
              r,←⊂'   version is published for the major version number 6 that will have a property "deprecated"'
              r,←⊂'   injected into its config file with the value 1.'
              r,←⊂'   It will also have a property "comment" that can carry stuff like "Use xyz instead".'
              r,←⊂' * If a package ID like "GroupName-PkgName is specified then new versions are published'
              r,←⊂'   for all major versions of that package.'
              r,←⊂''
              r,←⊂'2. Argument'
              r,←⊂'A text that will be injected into the package''s config file together with "deprecated".'
              r,←⊂''
              r,←⊂'-force     By default the user is questioned whether she is sure. With this flag this'
              r,←⊂'           can be overwritten. Mainly for tests.'
          :Case ⎕C'FindDependencies'
              r,←⊂'Scans the given folder for the given specified Tatin packages.'
              r,←⊂''
              r,←⊂'Note that the sequence of the arguments does not matter.'
              r,←⊂''
              r,←⊂'By default the folder(s) hosting the package(s) are returned, but that can be changed'
              r,←⊂'by specifying the -detailed flag:'
              r,←⊂''
              r,←⊂'-detailed  By setting this flag you can force the user command to report the actual'
              r,←⊂'           package folder(s) instead.'
              r,←⊂'           As a side effect the result might be larger, in case a package is'
              r,←⊂'           installed more than once.'
          :Case ⎕C'LoadTatin'
              r,←⊂'Load the Tatin client into ⎕SE (if it''s not already there) and initializes it.'
              r,←⊂'Allows accessing the Tatin API via ⎕SE.Tatin.'
              r,←⊂''
              r,←⊂'By default the user config file is expected in the user''s home folder, and it will be'
              r,←⊂'created there if it does not already exist.'
              r,←⊂'Instead you may specify a different folder. Note that this is NOT a permanent change;'
              r,←⊂''
              r,←⊂'-permanent   Make any changes permanent'
              r,←⊂'-force       Enforce the load even if ⎕SE.Tatin already exists'
          :Case ⎕C'ListRegistries'
              r,←⊂'List URL, alias, priority, port  and the no-caching flag of all Registries as defined'
              r,←⊂'in the user settings.'
              r,←⊂'The result is ordered by priority: the one with the highest priority is listed first etc.'
              r,←⊂''
              r,←⊂'Notes:'
              r,←⊂' * Registries with a priority of 0 will not participate in a scan of Registries'
              r,←⊂' * In case a Registry does not respond when questioned by ]ListRegistries the user is'
              r,←⊂'   given three options: Retry, skip and cancel operation'
              r,←⊂''
              r,←⊂'-full By default all data but the API keys are listed. Specify -full if you want the'
              r,←⊂'      API keys to be listed as well.'
          :Case ⎕C'ListDeprecated'
              r,←⊂'List all deprecated major versions'
              r,←⊂''
              r,←⊂'By default just the major versions would be listed.'
              r,←⊂''
              r,←⊂'-all    By specifying this flag you can force the command to list all versions of all'
              r,←⊂'        deprecated mnajor versions.'
          :Case ⎕C'ListPackages'
              r,←⊂'List all packages in the Registry or install folder specified. If no argument was specified'
              r,←⊂'then the principal Tatin Registry will be assumed (',tatinURL,'). If a "?" is passed as argument'
              r,←⊂'the user will be prompted for the Registry, except when there is just one anyway.'
              r,←⊂''
              r,←⊂'It does not matter whether you specify / or \ in a path, or whether it has or has not'
              r,←⊂'a trailing separator: Tatin is taking care of that.'
              r,←⊂''
              r,←⊂'In case an install folder was specified (rather than a Registry) flags are ignored and just'
              r,←⊂'two columns are returned: package name and a Boolean indicating principal packages with a 1.'
              r,←⊂''
              r,←⊂'By default all  packages are listed. You can influence the output in several ways:'
              r,←⊂'-group={foo}    List only packages with the given group name.'
              r,←⊂'-tags=foo,goo   List only packages carrying the tags "foo" & "goo".'
              r,←⊂'-os=mac         List only packages for the specified operating system(s). Must be a'
              r,←⊂'                comma-seperated list with "win", "mac", "lin" being valid values.'
              r,←⊂'-since=         Must be a date (YYYYMMDD or YYYY-MM-DD) when specified.'
              r,←⊂'                List only packages published on that date or later.'
              r,←⊂'                Implies -date and ignores -noaggr.'
              r,←⊂''
              r,←⊂'You can also influence the data returned with the following flags:'
              r,←⊂'-date           Add the publishing date to the output. -noaggr is set to 1 then.'
              r,←⊂'-project_url       Add the URL saved in the package config file to the result.'
              r,←⊂'-noaggr         By default the output is aggregated. -noaggr prevents that.'
          :Case ⎕C'LoadPackages'
              r,←⊂'Load the specified package(s) and all its dependencies into the workspace.'
              r,←⊂''
              r,←⊂'A) First argument:'
              r,←⊂'Specify one or more (comma-separated) packages to be loaded.'
              r,←⊂''
              r,←⊂'B) Second (optional) argument: target namespace (defaults to #)'
              r,←⊂'Must be the fully qualified name of a namespace the package will be loaded into.'
              r,←⊂'May be # or ⎕SE or a sub-namespace of any level.'
              r,←⊂''
              r,←⊂'Returns the number of packages loaded into the workspace, including dependencies.'
              r,←⊂''
              r,←HelpOnPackageID ⍬
          :Case ⎕C'InstallPackages'
              r,←⊂'Install the given package(s) and all its dependencies into a given folder.'
              r,←⊂'If the packages are already installed, they will be installed again from scratch.'
              r,←⊂'Requires two arguments:'
              r,←⊂''
              r,←⊂'A) First argument:'
              r,←HelpOnPackageID ⍬
              r,←⊂''
              r,←⊂'B) Second argument'
              r,←⊂'The optional second argument must be one of:'
              r,←⊂' * Path to a folder into which the packages are going to be installed'
              r,←⊂' * The alias [MyUCMDs] (case insensitive)'
              r,←⊂' * A Cider alias specifying a project'
              r,←⊂''
              r,←⊂'In case the second argument is relative Tatin checks whether there are open Cider projects.'
              r,←⊂'If there is just one, it is assumed that the installation should take place there.'
              r,←⊂'If there are multiple Cider projects open the user is questioned.'
              r,←⊂'If Cider is not available or no projects are opened then the current directory is checked.'
              r,←⊂'For a relative path the user is always asked for confirmation.'
              r,←⊂''
              r,←⊂'If no second argument is specified Tatin tries to find an open Cider project. If there is'
              r,←⊂'just one Tatin acts on it, otherwise the user is questioned.'
              r,←⊂'It then inspects the "tatinFolder" property. If that defines just one folder it is taken.'
              r,←⊂'If there are multiple folders defined the user is questioned which one to act on.'
              r,←⊂''
              r,←⊂'-quiet: Useful for test cases: it prevents Tatin from interrogating the user'
          :Case ⎕C'LoadDependencies'
              r,←⊂'Load all packages defined in a file apl-dependencies.txt.'
              r,←⊂''
              r,←⊂'Takes up to two arguments:'
              r,←⊂' [1] A folder into which one or more packages have been installed'
              r,←⊂' [2] Optional: a namespace into which the packages are going to be loaded; default is #'
              r,←⊂''
              r,←⊂'-overwrite: By default a package is not loaded if it already exists. You can enforce the'
              r,←⊂'            load by specifying the -overwrite flag.'
          :Case ⎕C'Maintenance'
              r,←⊂'Checks whether there are any files in the folder Maintenance/. These are expected to be'
              r,←⊂'.aplf files (functions). Such files will be listed, and the user can select which one(s)'
              r,←⊂'to execute. They will be fed with the argument provided, which is expected to be a folder.'
              r,←⊂'That folder and all its sub folders will be scanned for packages, and every package will'
              r,←⊂'be potentially changed by the maintenance file(s) selected by the user.'
              r,←⊂'Usually this means changing the package config file.'
              r,←⊂''
              r,←⊂'This mechanism can be used to, say, rename properties, or inject new ones. The purpose'
              r,←⊂'is to ensure that all packages are up to date.'
              r,←⊂''
              r,←⊂'-dry   When specified all actions will be listed, including a list of all packages found,'
              r,←⊂'       but no package will actually be changed at all.'
              r,←⊂'-show  Shows the leading comments of all maintenance files that would be executed.'
              r,←⊂'       If this is specified no other action is taken.'
              r,←⊂''
              r,←⊂'Note that this is NOT about packages that are managed by a Tatin server. The server has'
              r,←⊂'its own mechanism for updating packages.'
          :Case ⎕C'UserSettings'
              r,←⊂'Print the user settings found in the config file to the session in JSON format.'
              r,←⊂'By default the API key is replaced by asterisks; specify -apikey to overwrite this.'
              r,←⊂''
              r,←⊂'If you want to investigate the current user settings (rather than the file contents)'
              r,←⊂'please use the API.'
              r,←⊂''
              r,←⊂'-edit    If you want to change the file you can add -edit in order to get the data into'
              r,←⊂'         the editor and make changes. In this case the API key will always show.'
              r,←⊂'         If you did change the data, you will first be prompted for saving the changes on'
              r,←⊂'         disk and then for refreshing the current user settings.'
              r,←⊂''
              r,←⊂'-refresh If you did change the user settings from another APL session, or by editing the'
              r,←⊂'         file, you can refresh the current user settings with -refresh.'
          :Case ⎕C'PackageConfig'
              r,←⊂'Manage a package config file: fetch, create, edit or delete it.'
              r,←⊂'The argument, if specified, must be either a URL or a path.'
              r,←⊂' * In case of a URL the package config file is returned as JSON.'
              r,←⊂'   Specifying any of the options has no effect then.'
              r,←⊂' * In case of a path it must point to a folder that contains a Tatin package.'
              r,←⊂'   The contents of the file "',TC.CFG_Name,'" in that folder is returned.'
              r,←⊂'   In case the file does not yet exist it will be created.'
              r,←⊂''
              r,←⊂'In case no argument is specified Tatin checks whether there is an open Cider projects'
              r,←⊂'and asks the user whether that should be used.'
              r,←⊂''
              r,←⊂'If Cider is not available or no project is open the command tries to find a package'
              r,←⊂'config file in the current directory but the user is asked for confirmation.'
              r,←⊂''
              r,←⊂'-edit   You may edit the file by specifying the -edit flag.'
              r,←⊂'-delete In case you want to delete the file specify the -delete flag.'
              r,←⊂''
              r,←⊂'In case of success a text vector (with NLs) is returned, otherwise an empty vector.'
          :Case ⎕C'UnInstallPackage'
              r,←⊂'UnInstall a given package and implicitly all its dependencies, but only if those are'
              r,←⊂'neither top-level packages in their own rights nor required by other packages.'
              r,←⊂'In addition any superfluous packages (like outdated versions) are removed, too.'
              r,←⊂''
              r,←⊂'If you don''t want to delete a specific package but get rid of all superfluous packages'
              r,←⊂'then specify the -cleanup option. Note that you *must* not specify a package then.'
              r,←⊂''
              r,←⊂'Requires one argument in conjunction with the -cleanup option and two arguments otherwise:'
              r,←⊂'A single argument must be a folder. Two arguments must be a package-ID and a folder.'
              r,←⊂''
              r,←⊂' * First argument: a package identifier;  this can be one of:'
              r,←⊂'   * Fully qualified name of a package'
              r,←⊂'   * Alias and fully qualified name of a package'
              r,←⊂'   * Just an alias; post- or prefix with a "@" in order to mark it as alias'
              r,←⊂'   Might be a fully qualified packageID or <group>-<name> or even just <name>.'
              r,←⊂'   However, if more than just one package qualify an error is thrown.'
              r,←⊂''
              r,←⊂' * Second argument: path to a folder with installed packages'
              r,←⊂'   If this is not an absolute path then it might be a sub folder of an open Cider project.'
              r,←⊂'   Then Tatin works out the correct one:'
              r,←⊂'   * If there is just one project open it is taken'
              r,←⊂'   * If there are multiple Cider projects open the user is questioned'
              r,←⊂'   * If Cider is not available or no projects are open the current directory is checked'
              r,←⊂'   For a relative path the user is always asked for confirmation.'
          :Case ⎕C'PackageDependencies'
              r,←⊂'Return the contents of a file "apl-dependencies.txt".'
              r,←⊂'Takes a path hosting such a file as an argument.'
              r,←⊂''
              r,←⊂'-edit   You may edit the file by specifying the -edit flag. In case the file does not'
              r,←⊂'        already exist it is created.'
              r,←⊂''
              r,←⊂'        After an edit operation the data is checked for being complete and syntactically'
              r,←⊂'        correct JSON and then saved to the given folder.'
              r,←⊂''
              r,←⊂'-delete In case you want to delete the file specify the -delete flag.'
              r,←⊂''
              r,←⊂'-quiet  Useful for test cases: it prevents Tatin from interrogating the user'
          :Case ⎕C'PublishPackage'
              r,←⊂'Publish a package to a particular Tatin Registry.'
              r,←⊂'Such a package can be one of:'
              r,←⊂' * ZIP file, typically created by calling ]Tatin.BuildPackage'
              r,←⊂' * Folder that contains everything that defines a package; in this case the required ZIP is'
              r,←⊂'   created by "PublishPackage" itself.'
              r,←⊂''
              r,←⊂'Requires two arguments:'
              r,←⊂' * Path to ZIP file or package folder'
              r,←⊂' * URL or alias of a Registry or a "?"; you may or may not embrace it with []'
              r,←⊂''
              r,←⊂'The name of the resulting package is extracted from the ZIP file which therefore must conform'
              r,←⊂'to the Tatin rules.'
              r,←⊂''
              r,←⊂'Tatin checks the "delete" policy of the Registry. If the package cannot be deleted then the user'
              r,←⊂'must confirm that she really wants to publish to that particular Registry.'
              r,←⊂''
              r,←⊂'-dependencies=: Use this to specify a subfolder of the project that hosts the packages the package'
              r,←⊂'                about to be published depends on. Usually there is no need to specify this; refer'
              r,←⊂'                to the documentation ("Publishing Packages") for details.'
          :Case ⎕C'ListVersions'
              r,←⊂'List all versions of the given package.'
              r,←⊂''
              r,←⊂' You may specify a package in several ways:'
              r,←⊂' * ]Tatin.ListVersions [Registry-URL|Registry-alias]{group}-{package}'
              r,←⊂' * ]Tatin.ListVersions [Registry-URL|Registry-alias]{package}'
              r,←⊂' * ]Tatin.ListVersions {package}'
              r,←⊂' * ]Tatin.ListVersions {package}-{major}'
              r,←⊂' * ]Tatin.ListVersions {package}-{major}.{minor}'
              r,←⊂'In all these cases a list of packages is returned, possibly empty.'
              r,←⊂''
              r,←⊂'Note that case does not matter, meaning that a package MyGroup-MyPkg can be specified'
              r,←⊂'as mygroup-mypkg or MYGROUP-MYPKG, it does not matter.'
              r,←⊂''
              r,←⊂'You may not specify a Registry at all; in that case all Registries with a priority greater'
              r,←⊂'than zero are scanned.'
              r,←⊂'Finally you may specify a ? (or [?]): then you will be prompted with a list of all known'
              r,←⊂'Registries for selecting one.'
              r,←⊂''
              r,←⊂'If just a package is specified, a matrix with two columns is returned:'
              r,←⊂' [;1] The Registry'
              r,←⊂' [;2] Full package ID'
              r,←⊂''
              r,←⊂'Lacking a group does not make a difference if the package exists only in one group anyway.'
              r,←⊂'If it exists in more than one group then all of them are listed.'
              r,←⊂''
              r,←⊂'If version precedence cannot be established from the version numbers alone (often a problem'
              r,←⊂'with beta versions) then the publishing date is taken into account.'
              r,←⊂''
              r,←⊂'-date : adds the publishing date to the report.'
          :Case ⎕C'Version'
              r,←⊂'Prints name, version number and version date of Tatin to the session.'
              r,←⊂''
              r,←⊂' * Specify a URL or an alias if you are after the version number of a particular Tatin Registry'
              r,←⊂' * Specify "*" for all version numbers of the client and all known Tatin Registries; see also -all'
              r,←⊂' * Specify -all if you want to be prompted with a list of all available Tatin Registries; see also "*"'
              r,←⊂' * Specify "?" if you want to be prompted with a list of all available Tatin Registries'
              r,←⊂''
              r,←⊂'If you want to compare the version you are using locally with what is used on the principal'
              r,←⊂'Tatin Registry then specify the -check flag. Any argument is then ignored.'
          :Case ⎕C'ListTags'
              r,←⊂'List all unique tags as defined in all packages of a Registry, sorted alphabetically.'
              r,←⊂'If no argument was specified then the principal Tatin Registry will be assumed (',tatinURL,').'
              r,←⊂'If a "?" is passed as argument the user will be prompted for the Registry, except when there'
              r,←⊂'is just one defined anyway.'
              r,←⊂''
              r,←⊂'-tags=   You may specify one or more tags like -tags=foo,goo'
              r,←⊂'         In that case all tags are listed from packages that carry both "foo" & "goo".'
              r,←⊂'-os=     You may specify one or more operating systems as a comma-separated vector.'
              r,←⊂'         Only "lin", "mac" and "win" are valid.'
              r,←⊂'For details how tags are search refer to the documentation.'
          :Case ⎕C'Init'
              r,←⊂'(Re-)Establish the user settings in ⎕SE. Call this in case the user settings got changed on'
              r,←⊂'file and you want to incorporate the changes in the current session.'
              r,←⊂''
              r,←⊂'Without an argument Init processes the default user settings file.'
              r,←⊂'Instead you may specify a folder that contains a file tatin-client.json.'
          :Case ⎕C'CheckForLaterVersion'
              r,←⊂'Check whether later versions of the installed packages are available.'
              r,←⊂'Takes a folder that hosts a file "apl-buildlist.json" as argument.'
              r,←⊂'Scans all known Registries with a priority greater than 0 for later versions.'
              r,←⊂'Note that if you''ve loaded a package from a Registry that has been removed since, or has a '
              r,←⊂'priority of 0, then Tatin won''t be able to find any later versions!'
              r,←⊂''
              r,←⊂'Returns a matrix with five columns for all packages found:'
              r,←⊂' [;1] Currently installed package ID'
              r,←⊂' [;2] package ID of the latest version found or something like "no response" or "not found"'
              r,←⊂' [;3] URL of the Registry the package was originally installed from'
              r,←⊂' [;4] ! for a later version'
              r,←⊂' [;5] URL of the Registry hosting a different (usually later) version; might be empty'
              r,←⊂''
              r,←⊂'-major        By default later MAJOR versions are ignored, but this default behaviour can be'
              r,←⊂'              changed by specifying -major: then only later major versions are reported.'
              r,←⊂''
              r,←⊂'-dependencies By default only principal packages are checked.'
              r,←⊂'              You may include dependencies by specifying this flag.'
          :Case ⎕C'DeletePackage'
              r,←⊂'Delete a given package.'
              r,←⊂''
              r,←⊂'Takes one of:'
              r,←⊂' * URL specifying a Tatin Registry, followed by a full package ID'
              r,←⊂' * [alias] specifying a Tatin Registry, followed by a full package ID'
              r,←⊂' * Folder hosting a package; must start with file://'
              r,←⊂'   The folder must contain a file apl-package.json, otherwise an error is thrown'
              r,←⊂''
              r,←⊂'Whether a package can be deleted depends on the delete policy operated by a given Registry.'
              r,←⊂'A Registry may allow...'
              r,←⊂' * no deletion at all'
              r,←⊂' * deletion of beta versions only'
              r,←⊂' * everything'
          :Case ⎕C'GetDeletePolicy'
              r,←⊂'Request which "Delete" policy is operated by a Registry.'
              r,←⊂'Return one of "None", "Any", "JustBetas":'
              r,←⊂' * "None" means a package, once published, cannot be deleted'
              r,←⊂' * "Any" means any package can be deleted'
              r,←⊂' * "JustBetas" means that only beta versions can be deleted'
              r,←⊂'If no Registry is specified the user will be prompted, unless there is just one anyway.'
              r,←⊂''
              r,←⊂'Note that Tatin interrogates all known Registries for their delete policies just once. It'
              r,←⊂'then saves the results on a variable for better performance. This can be a problem is case the'
              r,←⊂'policy of a server got changed, most likely your own one. To overcome this specify the -check'
              r,←⊂'flag which will result in the servers being asked again rather than trusting former results.'
          :Case ⎕C'Documentation'
              r,←⊂'Put ',tatinURL,'/v1/documentation into the default browser'
          :Case ⎕C'ReInstallDependencies'
              r,←⊂'ReInstall all packages (principals as well as dependencies) from scratch.'
              r,←⊂'Takes a folder as mandatory argument. That folder must host a file apl-dependencies.txt.'
              r,←⊂'If this is not an absolute path then it might be a sub folder of an open Cider project.'
              r,←⊂'Then Tatin works out the correct one:'
              r,←⊂' * If there is just one project open it is taken'
              r,←⊂' * If there are multiple Cider projects open the user is questioned'
              r,←⊂' * If Cider is not available or no projects are open the current directory is checked'
              r,←⊂'For a relative path the user is always asked for confirmation.'
              r,←⊂''
              r,←⊂'All installed packages are removed (except ZIP files) from the folder before a new build'
              r,←⊂'list is compiled and used to install all packages from scratch.'
              r,←⊂''
              r,←⊂'Notes:'
              r,←⊂' * This does not install a later version (but check on -update). In fact as a side'
              r,←⊂'   effect of minimal version selection you might end up with an older version under'
              r,←⊂'   specific (and pretty rare) circumstances.'
              r,←⊂' * ZIP files are not removed upfront and have therefore a higher priority,'
              r,←⊂'   so when the dependency list refers to a ZIP file then it will always survive.'
              r,←⊂''
              r,←⊂'All defined Registries with a priority greater than 0 are scanned for principal packages'
              r,←⊂'but one can specify a particular Registry as second (optional) argument.'
              r,←⊂'For dependencies, all Registries with a priority greater than 0 are scanned in any case.'
              r,←⊂''
              r,←⊂'-force   Prevents user confirmation and reporting to the session, including establishing'
              r,←⊂'         a project in case no folder was specified.'
              r,←⊂'-dry     Report what would be done without actually doing it.'
              r,←⊂'-nobetas By default betas are included; suppress with -nobetas.'
              r,←⊂'-update  By default ReInstallDependencies does not install later versions.'
              r,←⊂'         You may change this by specifying this flag.'
          :Case ⎕C'Ping'
              r,←⊂'Try to contact one or more Tatin Registries.'
              r,←⊂''
              r,←⊂' * Optionally you may specify a Registry URL as an argument.'
              r,←⊂' * You can also specify just a "?"; then a list with all known Registries will be provided.'
              r,←⊂'   You may then select one or multiple of them.'
              r,←⊂' * If no argument is provided at all then all defined Registries are contacted.'
              r,←⊂' * In case the path to a folder is passed as ⍵ a 1 is returned in case the folder exists.'
              r,←⊂''
              r,←⊂'In any case a matrix with two columns is returned:'
              r,←⊂' [;1] is the Registry URL'
              r,←⊂' [;2] is a Boolean, a 1 means that the Registry responded'
          :Case ⎕C'Cache'
              r,←⊂'By default all packages of all URLs saved in the Tatin package cache are listed.'
              r,←⊂''
              r,←⊂'One may specify a URL as argument; then only packages of that URL are listed.'
              r,←⊂''
              r,←⊂'-path  By default just domain names and package names are returned. By specifying this'
              r,←⊂'       option you can force it to return full paths instead.'
              r,←⊂'-clear Lists all cached packages and then asks for confirmation before removing them.'
              r,←⊂'       If confirmed all packages are removed or, if an argument (URL) was specified,'
              r,←⊂'       all packages of that URL.'
              r,←⊂'-force Ignored in case -clear was not specified as well. Prevents the user from being'
              r,←⊂'       interrogated regarding clearing the cache. Mainly for test cases.'
          :Case ⎕C'UsageData'
              r,←⊂'Use this to deal with usage data of a Tatin Registry.'
              r,←⊂'If no argument is specified then the user will be prompted for the Registry,'
              r,←⊂'except when there is just one anyway.'
              r,←⊂'If no option is specified all available files will be listed.'
              r,←⊂''
              r,←⊂'If only a URL (or Registry alias) is specified a list with all downloadable files is printed.'
              r,←⊂''
              r,←⊂'-download Use this flag to indicate that you wish to download one or more files.'
              r,←⊂'          A list with all files available for download will be presented to you together'
              r,←⊂'          with the additional options "all" and "quit". You may then select none, one,'
              r,←⊂'          several or all files for download or cancel the operation.'
              r,←⊂'          The folder holding the file(s) is printed together with a list of all files.'
              r,←⊂'-folder=  By default downloaded files will be saved in a sub folder of your OS''s temp'
              r,←⊂'          folder which is printed to the session. You may override this by specifying a folder.'
              r,←⊂'          If you do it must be an empty folder. Ignored when -download is not specified.'
              r,←⊂'-unzip    Specify this if you want Tatin to unzip the downloaded file(s).'
              r,←⊂'          The ZIP files will be deleted afterwards. Ignored when -download is not specified.'
              r,←⊂'-all      This circumvents the selection dialog; mainly useful for test cases.'
          :Case ⎕C'UpdateTatin'
              r,←⊂'Downloads the latest version from GitHub and installs it in the folder it was started from.'
              r,←⊂''
              r,←⊂'Note that this user command does not attempt to update the current workspace, therefore it'
              r,←⊂'is recommended to close the current session and start a new one.'
          :Else
              r←'Unknown command: ',Cmd
          :EndSelect
          :If (⊂⎕C Cmd)∊⎕C¨'LoadPackages' 'InstallPackages' 'DeletePackage' 'ReInstallDependencies' 'Ping'
          :AndIf (⎕C∊r)≢⎕C'Unknown command: ',Cmd
              r,←''(']',Cmd,' -??? ⍝ Enter this for examples ')
          :EndIf
      :Case 2
          :Select ⎕C Cmd
          :Case ⎕C'LoadTatin'
          :Case ⎕C'ListRegistries'
          :Case ⎕C'ListPackages'
          :Case ⎕C'LoadPackages'
              r,←⊂'Examples:'
              r,←⊂'  ]Tatin.LoadPackages group-name-2.0.0                ⍝ Just full package ID without Registry'
              r,←⊂'  ]Tatin.LoadPackages [tatin]group-name-1.0           ⍝ Alias & package ID without patch no.'
              r,←⊂'  ]Tatin.LoadPackages [tatin]group-name-1             ⍝ Without patch and minor no.'
              r,←⊂'  ]Tatin.LoadPackages [tatin]group-name               ⍝ With any version information'
              r,←⊂'  ]Tatin.LoadPackages [tatin]/group-name-1.0.0        ⍝ With "/"'
              r,←⊂'  ]Tatin.LoadPackages [tatin]group-name-1.0.0         ⍝ Without "/"'
              r,←⊂'  ]Tatin.LoadPackages [tatin]name #                   ⍝ With target namespace'
              r,←⊂'  ]Tatin.LoadPackages [tatin]A@name #                 ⍝ With package alias'
              r,←⊂'  ]Tatin.LoadPackages name #                          ⍝ No Registry and no group'
              r,←⊂'  ]Tatin.LoadPackages A@name                          ⍝ No Registry and no group but alias'
              r,←⊂'  ]Tatin.LoadPackages A@name #.Foo.Goo                ⍝ With target namespace'
              r,←⊂'  ]Tatin.LoadPackages file:///path/group-name-1.0.0/  ⍝ Local Registry'
              r,←⊂'  ]Tatin.LoadPackages foo,bar                         ⍝ Multiple packages'
          :Case ⎕C'InstallPackages'
              r,←⊂'Examples:'
              r,←⊂'  ]Tatin.InstallPackages [tatin]/group-name-1.0.0 /path           ⍝ Alias & package ID with "/"'
              r,←⊂'  ]Tatin.InstallPackages [tatin]group-name-1.0.0 /path            ⍝ Alias & package ID without "/"'
              r,←⊂'  ]Tatin.InstallPackages [tatin]group-name-1.0 /path              ⍝ No patch no'
              r,←⊂'  ]Tatin.InstallPackages [tatin]group-name-1 /path                ⍝ Neither patch nor minor no.'
              r,←⊂'  ]Tatin.InstallPackages [tatin]group-name /path                  ⍝ No version information at all'
              r,←⊂'  ]Tatin.InstallPackages [tatin]name /path                        ⍝ No group and no version information'
              r,←⊂'  ]Tatin.InstallPackages [tatin]A@name /path                      ⍝ Registry alias and package alias'
              r,←⊂'  ]Tatin.InstallPackages group-name-2.0.0 /path                   ⍝ Just a full package ID'
              r,←⊂'  ]Tatin.InstallPackages name /path                               ⍝ Just a package name'
              r,←⊂'  ]Tatin.InstallPackages A@name /path                             ⍝ Just a package name & a package alias'
              r,←⊂'  ]Tatin.InstallPackages file:///path/group-name-1.0.0/ /install/ ⍝ Package in a local Registry'
              r,←⊂'  ]Tatin.InstallPackages faoo,bar /install/                       ⍝ Multiple packages'
          :Case ⎕C'LoadDependencies'
          :Case ⎕C'UserSettings'
          :Case ⎕C'PackageConfig'
          :Case ⎕C'UnInstallPackage'
          :Case ⎕C'PackageDependencies'
          :Case ⎕C'BuildPackage'
          :Case ⎕C'PublishPackage'
          :Case ⎕C'ListVersions'
          :Case ⎕C'Version'
          :Case ⎕C'ListTags'
          :Case ⎕C'Init'
          :Case ⎕C'CheckForLaterVersion'
          :Case ⎕C'DeletePackage'
              r,←⊂'Examples:'
              r,←⊂'  ]Tatin.DeletePackage https:/tatin.dev/group-name-1.0.0 ⍝ Registry URL & package ID'
              r,←⊂'  ]Tatin.DeletePackage [test-tatin]group-name-1.0.0      ⍝ Registry alias & package ID'
              r,←⊂'  ]Tatin.DeletePackage C:\My\Registry\group-name-1.0.0   ⍝ Local package'
          :Case ⎕C'GetDeletePolicy'
              r←'Not ready yet'
          :Case ⎕C'Documentation'
          :Case ⎕C'ReInstallDependencies'
              r,←⊂'Examples:'
              r,←⊂'  ]Tatin.ReInstallDependencies /path/'
              r,←⊂'  ]Tatin.ReInstallDependencies /path/ [tatin]'
              r,←⊂'  ]Tatin.ReInstallDependencies /path/ [tatin] -nobetas'
              r,←⊂'  ]Tatin.ReInstallDependencies /path/ [tatin] -nobetas -dry'
              r,←⊂'  ]Tatin.ReInstallDependencies /path/ [tatin] -nobetas -force'
              r,←⊂'  ]Tatin.ReInstallDependencies /path/ [tatin] -nobetas -force -update'
          :Case ⎕C'Ping'
              r,←⊂'Examples:'
              r,←⊂'  ]Tatin.Ping'
              r,←⊂'  ]Tatin.Ping ?'
              r,←⊂'  ]Tatin.Ping [tatin]'
              r,←⊂'  ]Tatin.Ping ',tatinURL
              r,←⊂'  ]Tatin.Ping http://tatin.dev   ⍝ This won''t work'
          :Else
                  ⍝ Not available then
          :EndSelect
      :EndSelect
    ∇

    ∇ r←HelpOnPackageID dummy
      r←''
      r,←⊂'You may specify a Tatin alias for a package by putting it to the front and'
      r,←⊂'separate it with an @.'
      r,←⊂''
      r,←⊂'Note that if neither a Registry nor a ZIP file is specified but just a package ID'
      r,←⊂'(partly or fully) then all defined Registries with a priority of greater than 0'
      r,←⊂'will be scanned; the first hit wins.'
      r,←⊂''
      r,←⊂'Note that case does not matter, meaning that package MyGroup-MyPkg-1.2.3 can also'
      r,←⊂'be specified as mygroup-mypkg-1.2.3 or MYGROUP-MYPKG-1.2.3.'
      r,←⊂''
      r,←⊂'A package might be:'
      r,←⊂' * A full package ID.'
      r,←⊂'   A full package ID has three components: {group}-{name}-{major.minor.patch}.'
      r,←⊂' * You may also specify an incomplete package ID in terms of no patch number, or'
      r,←⊂'   neither minor nor patch number, or no version information at all, and leave'
      r,←⊂'   it to Tatin to establish the latest version itself.'
      r,←⊂' * You may also omit the group. This will fail in case the same package name is'
      r,←⊂'   used in two or more different groups but will succeed otherwise.'
      r,←⊂' * Either a full path or an http[s] URL in front of the package ID.'
      r,←⊂''
      r,←⊂'-nobetas: By default beta versions are included. Specify -nobetas to suppress them.'
    ∇

    ∇ errMsg←CheckDependencies txt;f1;f2;f3;f
    ⍝ Every single line must have at least a group name and a package name
    ⍝ but optionally also major.minor.patch
      f1←TC.Reg.IsValidPackageID_Complete¨txt
      f2←TC.Reg.IsValidPackageID_WithMajorNo¨txt
      f3←TC.Reg.IsValidPackageID_WithoutVersionNo¨txt
      errMsg←''
      :If ∨/~f←f1+f2+f3
          :If 1=+/~f
              errMsg←'Not a valid package ID: ',⊃(~f)/txt
          :Else
              errMsg←'Not valid package IDs: ',⊃{⍺',',⍵}/(~f)/txt
          :EndIf
      :EndIf
    ∇

    ∇ (msg json)←CheckPackageConfigFile(json path);cfg2;ns;extensions;⎕TRAP;list
        ⍝ Returns an empty vector if everything is okay and an error message otherwise
      msg←''
      ns←⎕JSON⍠('Dialect' 'JSON5')⊣json
      :Trap ErrNo
          cfg2←TC.InitPackageConfig ns
          'name'TC.ValidateName ns.name
          'group'TC.ValidateName ns.group
          {}'api'TC.ValidateName⍣(0<≢ns.api)⊣ns.api
          TC.ValidateVersion ns.version
          ns←TC.ValidateTags ns
          ns←TC.ValidateDescription ns
          ns←TC.ValidateAplVersion ns
          ns←TC.ValidateOSprops ns
          :If 0=≢ns.source
              list←(1+≢path)↓¨⊃TC.F.Dir path,'\'
              list~←⊂TC.CFG_Name
              :If 1=≢list
              :AndIf ((⊂3⊃⎕NPARTS⊃list)∊'.apln' '.aplc')∨TC.F.IsDir path,⊃list
                  ns.source←⊃list
              :Else
                  msg←'Invalid: "source"'
                  :Return
              :EndIf
          :EndIf
          {}{{'source'TC.ValidateName ⍵}⍣(0<≢⍵)⊣⍵}ns.source~'/\'
          :If '.'∊ns.source
              '"source" carries an invalid extension'Assert(⊂3⊃⎕NPARTS ns.source)∊SupportedExtensions
          :EndIf
          :If 0<≢ns.project_url
              :If 0=TC.SendHEAD ns.project_url
                  msg←ns.project_url,' did not respond'
                  :Return
              :EndIf
          :EndIf
          json←TC.Reg.JSON ns
      :Else
          msg←⎕DMX.EM
      :EndTrap
    ∇

    Assert←{⍺←'' ⋄ (,1)≡,⍵:r←1 ⋄ ⎕ML←3 ⋄ (⍕∊⍺) ⎕SIGNAL 1↓(↑∊⍵),ErrNo}
    AddHeader←{0=≢⍺:⍺ ⋄(⍵,[0.5]'-'⍴¨⍨≢¨⍵)⍪⍺}
    EnforceSlash←{'/'@(⍸'\'=⍵)⊣⍵}
    IsScripted←{0::1 ⋄0⊣⎕src ⍵}
    ED←{⎕ED⍠('EditName' 'Disallow')⊣⍵}
    IsValidJSON←{0::0 ⋄ 1⊣TC.Reg.JSON ⍵}
    IfAtLeastVersion←{⍵≤{⊃(//)⎕VFI ⍵/⍨2>+\'.'=⍵}2⊃# ⎕WG'APLVersion'}

    ∇ r←DefineTargetSpace dummy;bool;ind;NSI
      NSI←(⎕NSI≢¨⊂⍕##.THIS)/⎕NSI
      r←,⊃1↑(+/'⎕SE'{∧\⍺∘≡¨(≢⍺)↑¨⍵}NSI)↓NSI,'#'
      :If '['∊r   ⍝ Might be called from an instance of a class
          r←{⍵↓⍨-'.'⍳⍨⌽⍵}{⍵↑⍨⍵⍳'['}r
      :EndIf
      :If (,'#')≢r
          ind←'Select target space the package(s) shall be loaded into:'TC.C.Select,¨'#'(⍕r)
          :If 0=≢ind
              r←''
          :Else
              r←ind⊃,¨'#'(⍕r)
          :EndIf
      :EndIf
    ∇


    ∇ r←GetListOfRegistriesForSelection type
      :If 0<≢r←TC.ListRegistries type
          r[;2]←{0=≢⍵:'' ⋄ '[',⍵,']'}¨r[;2]
          r[;1]←r[;1]{⍵∊0 80 443:⍺ ⋄ (¯1↓⍺),':',(⍕⍵),'/'}¨r[;3]
      :EndIf
    ∇

    ∇ registry←{all}SelectRegistry type;row;list
      all←{0<⎕NC ⍵:⍎⍵ ⋄ 0}'all'
      :If 1=≢list←GetListOfRegistriesForSelection type
          registry←1⊃list[1;]
      :Else
          :If ⍬≡row←'Select Tatin Registry'all TC.C.Select↓⎕FMT list[;2 1]
              registry←⍬
          :Else
              :If all
                  registry←list[,row;1]
              :Else
                  registry←1⊃list[row;]
              :EndIf
          :EndIf
      :EndIf
    ∇

    ∇ r←GetTitleFromHtml html;offset
      offset←⊃'<title[^>]*>([^<]+)'⎕S 0⍠('Greedy' 0)('IC' 1)('Mode' 'M')⊣html
      r←offset↓html
      r↓⍨←r⍳'>'
      r↑⍨←¯1+r⍳'>'
      r↑⍨←¯1+r⍳'<'
      ⍝Done
    ∇

    ∇ r←EditJSON data;ns;flag
      flag←0
      ns←#.⎕NS''
      ns.UserSettings←data
      :Repeat
          ns.⎕ED'UserSettings'
          :If 0=≢ns.UserSettings
              r←⍬
              flag←1
          :Else
              :If {0::1 ⋄ 0⊣JSON ⍵}{b←';'≠⊃¨d←(⎕UCS 10)(≠⊆⊢)⍵ ⋄ 1↓⊃,/(⎕UCS 10),¨b/d}ns.UserSettings
                  :If ~1 TC.C.YesOrNo'The JSON is invalid; would you like to edit it again? ("N"=drop out without change)'
                      r←''
                      flag←1
                  :EndIf
              :Else
                  r←ns.UserSettings
                  flag←1
              :EndIf
          :EndIf
      :Until flag
    ⍝Done
    ∇

    JSON←{⎕JSON⍠('Dialect' 'JSON5')⊣⍵}
    AddSlash←{0=≢⍵:⍵ ⋄ ⍵,(~(¯1↑⍵)∊'/\')/'/'}

    ∇ r←CR
      r←⎕UCS 13
    ∇

    IsAbsolutePath←{'/'=1⍴⍵:1 ⋄ ':'∊⍵:1 ⋄ '//'≡2↑⍵}

    ∇ folder←{quietFlag}EstablishPackageFolder folder;list;ind
    ⍝ Checks first whether it's meant to be an open Cider project (if Cider is around).
    ⍝ Next it tries to find it in the current dir.
    ⍝ The user should always be asked for confirmation.
    ⍝ If `folder` is relative and there are more than one Cider projects open then the user
    ⍝ is asked which one she wants to act on except when `quiteFlag` is 1 (default is 0)
    ⍝ when an error is generated instead.
      quietFlag←{0<⎕NC ⍵:⍎⍵ ⋄ 0}'quietFlag'
      :If ~IsAbsolutePath folder
          :If 0<⎕SE.⎕NC'Cider'
              :If 1=≢list←⎕SE.Cider.ListOpenProjects 0
                  folder←'expand'TC.F.NormalizePath(2⊃list[1;]),'/',folder
              :ElseIf 0=≢list
                  :If TC.F.IsDir TC.F.PWD,'/',folder
                      folder←TC.F.PWD,'/',folder
                  :Else
                      ('Not found: ',folder)Assert 0
                  :EndIf
              :Else
                  :If quietFlag
                      ('Folder does not exist: ',folder)⎕SIGNAL ErrNo
                  :Else
                      ind←'For which project?'TC.C.Select↓⍕list
                      :If 0=≢ind
                          folder←0⍴⎕←'Cancelled by user'
                      :Else
                          folder←(⊃list[ind;2]),'/',folder
                          ('Folder does not exist: ',folder)Assert TC.F.IsDir folder
                      :EndIf
                  :EndIf
              :EndIf
          :Else
              :If TC.F.IsDir TC.F.PWD,'/',folder
                  folder←TC.F.PWD,'/',folder
              :EndIf
          :EndIf
      :EndIf
    ∇

    ∇ {r}←CheckForInvalidVersion dmx;v;f2;f1
      r←0
      f1←'Server: Request came from an invalid version of Tatin.'{⍺≡(≢⍺)↑⍵}dmx.EM
      ⍝ Workaround for Client and Server being out of sync after injecting the originally missing "an" into the message:
      f2←'Server: Request came from invalid version of Tatin.'{⍺≡(≢⍺)↑⍵}dmx.EM
      :If f1∨f2
      :AndIf 1 TC.C.YesOrNo'You are using an outdated version of the Tatin client.',CR,'Would you like to update automatically?'
          :Trap ErrNo
              v←⊃TC.UpdateClient 1
              ⎕←'Tatin client updated to ',v,'; please execute the last Tatin user command again'
          :Else
              dmx←⎕DMX
              :If ∨/'Check ⎕EXCEPTION for details'⍷dmx.Message
                  ⎕EXCEPTION.Message ⎕SIGNAL ErrNo
              :Else
                  dmx.EM ⎕SIGNAL ErrNo
              :EndIf
          :EndTrap
      :EndIf
    ∇

:EndNamespace
