:Namespace Tatin
⍝ The ]Tatin user commands for managing packages.\\
⍝ * 0.37.0 - 2022-03-19

    ⎕IO←1 ⋄ ⎕ML←1

    NM←'tatin'
    RS←'#._tatin' ⍝ target Root Space for packages
    SupportedExtensions←'.aplc' '.apln' '.apli' '.aplf' '.aplo' '.apla' '.charlist' '.charmat' '.charstring' '.dyalog'
    RegKey←'HKCU\Software\Tatin\ConfigPath'

    ∇ r←List;c
      r←⍬
     
      :If IfAtLeastVersion 18
     
          c←⎕NS ⍬
          c.Name←'LoadTatin'
          c.Desc←'Loads the Tatin client into ⎕SE, resulting in ⎕SE.Tatin, and initializes it'
          c.Parse←'1s -force'
          r,←c
     
          c←⎕NS ⍬
          c.Name←'ListRegistries'
          c.Desc←'Lists all registries defined in the user settings'
          c.Parse←'0 -full'
          r,←c
     
          c←⎕NS ⍬
          c.Name←'ListPackages'
          c.Desc←'Lists all packages in the Registry or install folder specified in the argument'
          c.Parse←'1s -group= -tags= -noaggr -date -info_url -since='
          r,←c
     
          c←⎕NS ⍬
          c.Name←'LoadPackage'
          c.Desc←'Load the package specified in the argument and all dependencies into the WS or ⎕SE'
          c.Parse←'1-2 -nobetas'
          r,←c
     
          c←⎕NS ⍬
          c.Name←'ListVersions'
          c.Desc←'Lists all versions of the specified package'
          c.Parse←'1 -date'
          r,←c
     
          c←⎕NS ⍬
          c.Name←'InstallPackage'
          c.Desc←'Install a package and all its dependencies into a given folder'
          c.Parse←'1-2 -nobetas -quiet'
          r,←c
     
          c←⎕NS ⍬
          c.Name←'LoadDependencies'
          c.Desc←'Takes a folder (⍵[1]) with installed packages and loads all of them into ⍵[2].'
          c.Parse←'1-2 -overwrite'
          r,←c
     
          c←⎕NS ⍬
          c.Name←'UserSettings'
          c.Desc←'The user settings and the fully qualified filenanme are printed to ⎕SE as JSON'
          c.Parse←'0 -edit -apikey -refresh'
          r,←c
     
          c←⎕NS ⍬
          c.Name←'PackageConfig'
          c.Desc←'Retrieve (HTTP) or create and/or edit a package config file for a specific package'
          c.Parse←'1s -delete -edit -quiet'
          r,←c
     
          c←⎕NS ⍬
          c.Name←'PackageDependencies'
          c.Desc←'Create and/or edit a package dependency file for a specific folder'
          c.Parse←'1 -delete -edit -quiet'
          r,←c
     
          c←⎕NS ⍬
          c.Name←'Pack'
          c.Desc←'Packs (zips) all required files found in ⍵[1] into the folder ⍵[2]'
          c.Parse←'2s'
          r,←c
     
          c←⎕NS ⍬
          c.Name←'PublishPackage'
          c.Desc←'Publish a package (package folder or ZIP file) to a particular Registry'
          c.Parse←'2 -quiet'
          r,←c
     
          c←⎕NS ⍬
          c.Name←'Version'
          c.Desc←'Prints name, version number and version date of the client to the session'
          c.Parse←'1s'
          r,←c
     
          c←⎕NS ⍬
          c.Name←'ListTags'
          c.Desc←'Lists all tags used in all packages'
          c.Parse←'1s -tags='
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
          c.Desc←'Loads the documentation center into the default browser'
          c.Parse←''
          r,←c
     
          c←⎕NS ⍬
          c.Name←'DeletePackage'
          c.Desc←'Delete a package from a Tatin Registry'
          c.Parse←'1'
          r,←c
     
          c←⎕NS ⍬
          c.Name←'GetDeletePolicy'
          c.Desc←'Asks the server about its "Delete" policy'
          c.Parse←'1s'
          r,←c
     
          c←⎕NS ⍬
          c.Name←'UninstallPackage'
          c.Desc←'Uninstalls a package and its dependencies'
          c.Parse←'2s'
          r,←c
     
          c←⎕NS ⍬
          c.Name←'ReinstallDependencies'
          c.Desc←'Install all packages again according to the dependency file'
          c.Parse←'2s -nobetas -dry -force -update'
          r,←c
     
          c←⎕NS ⍬
          c.Name←'Ping'
          c.Desc←'Ping Tatin server(s) with very little overhead'
          c.Parse←'1s'
          r,←c
     
          r.Group←⊂NM
     
      :EndIf
     
    ∇

    ∇ {r}←Run(Cmd Input);ns;flag
      :If 0=⎕SE.⎕NC'Link.Version'
      :OrIf 3>⊃(//)⎕VFI{⍵↑⍨¯1+⍵⍳'.'}⎕SE.Link.Version
          'Tatin requires at least Link 3.0'⎕SIGNAL 998
      :EndIf
      :If 0=⎕SE.⎕NC'Tatin'
      :AndIf ≢/⎕C¨'LoadTatin'Cmd
          flag←LoadTatin''
      :EndIf
      :If ≡/⎕C¨'loadtatin'Cmd
          Input.force LoadTatin(1+(0≡Input._1)∨0=≢Input._1)⊃Input._1''
          r←''
      :Else
          TC←⎕SE._Tatin.Client
          :If 0=⎕SE._Tatin.RumbaLean.⎕NC'DRC'
              ⎕SE._Tatin.Admin.InitConga ⍬
          :EndIf
          r←((⍎Cmd)__ExecAsTatinUserCommand)Input
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

    ∇ r←Version Arg;⎕TRAP;registries;registry;alias
      ⎕TRAP←0 'S'
      :If (,'*')≡,Arg._1
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
      :Else
          r←TC.GetServerVersion Arg._1
      :EndIf
    ∇

    ∇ {r}←LoadTatin_ forceLoad;filename
      r←1
      filename←(1⊃⎕NPARTS ##.SourceFile),'/Client.dws'
      :If 0∊⊃∘⎕SE.⎕NC¨'Tatin' '_Tatin'
      :OrIf forceLoad
          ('Workspace not found: ',filename)⎕SIGNAL 998/⍨0=⎕NEXISTS filename
          ⎕SE.⎕EX¨'_Tatin' 'Tatin'
          '_Tatin'⎕SE.⎕CY filename
      :EndIf
      'Tatin requires .NET to be available'⎕SE._Tatin.Registry.Assert ⎕SE._Tatin.Registry.HasDOT_NET
      TC←⎕SE._Tatin.Client
    ∇

    ∇ r←ListPackages Arg;registry;parms
      r←''
      :If 0≡registry←Arg._1
          →(⍬≡registry←SelectRegistry 0)/0
      :Else
          registry,←(~(¯1↑registry)∊'/\')/'/'
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
      parms.info_url←Arg.info_url
      r←⍪parms TC.ListPackages registry
      :If 0=≢r
          r←'No packages found'
      :Else
          :If TC.IsInstallFolder registry
              r[;2]←' *'[1+r[;2]]
              r(AddHeader)←'Package-ID' 'Principal'
          :Else
              :If 0≡parms.date
                  r(AddHeader)←(2⊃⍴r)↑(⊂'Group & Name'),((parms.aggregate)/⊂'≢ major versions'),(⊂'Info URL')
              :Else
                  r(AddHeader)←(2⊃⍴r)↑'Group & Name' 'Published at' 'Info URL'
              :EndIf
              r←((2⊃⍴r)↑'Packages from:'registry,(2⊃⍴r)⍴⊂'')⍪r
          :EndIf
      :EndIf
    ∇

    ∇ r←LoadDependencies Arg;installFolder;f1;f2;targetSpace;saveIn;overwriteFlag
      installFolder←Arg._1
      :If 0≡Arg._2
          targetSpace←,'#'
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

    ∇ r←CheckForLaterVersion Arg;path;question;this;b;flags;colHeaders
      r←''
      path←Arg._1
      flags←(1×Arg.major)+(2×Arg.dependencies)
      r←flags TC.CheckForLaterVersion path
      :If 0<≢r
          colHeaders←'Installed' 'Latest' 'OriginalURL' '?'
          colHeaders,←'New URL' ''[1+0<+/≢¨r[;5]]
          r←colHeaders⍪' '⍪r
          r[2;]←(⌈⌿≢¨r)⍴¨'-'
          b←1≡¨r[;4]
          r[⍸b;4]←'*'
          r[2↓⍸~b;4]←⊂''
      :EndIf
    ∇

    ∇ r←ReinstallDependencies Args;installFolder;registry;refs;deps;msg;parms
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
      installFolder←'apl-dependencies.txt'{⍵↓⍨(-≢⍺)×⍺≡⎕C(-≢⍺)↑⍵}installFolder
      'Not a directory'Assert TC.F.IsDir installFolder
      'Directory does not host a file apl-dependencies.txt'Assert TC.F.IsFile installFolder,'/apl-dependencies.txt'
      deps←⊃TC.F.NGET(installFolder,'/apl-dependencies.txt')1
      'Dependency file is empty'Assert 0<≢deps
      :If parms.force
      :OrIf ∆YesOrNo'Re-install ',(⍕≢deps),' Tatin packages in ',installFolder,'?'
          r←parms TC.ReInstallDependencies installFolder registry
          :If ~parms.force
              ⎕←'*** Done'
          :EndIf
      :EndIf
    ∇

    ∇ msg←DeletePackage Arg;path;msg;statusCode
      path←Arg._1
      (statusCode msg)←TC.DeletePackage path
      :If 200=statusCode
          msg←'Package was successfully deleted'
      :EndIf
     ⍝Done
    ∇

    ∇ r←GetDeletePolicy Arg;uri
      r←⍬
      uri←Arg._1
      :If 0≡Arg._1
          →(⍬≡uri←SelectRegistry 0)/0
      :EndIf
      r←TC.GetDeletePolicy uri
    ∇

    ∇ zipFilename←Pack Arg;filename;sourcePath;targetPath;prompt;msg
      (sourcePath targetPath)←Arg.(_1 _2)
      prompt←0
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
      :AndIf 0=1 ∆YesOrNo msg
          :Return
      :EndIf
      :If 0=⎕NEXISTS targetPath
      :AndIf 1 ∆YesOrNo'Target directory does not exist yet; create it?'
          TC.F.MkDir targetPath
      :EndIf
      'Target path (⍵[2]) is not a directory'Assert TC.F.IsDir targetPath
      zipFilename←TC.Pack sourcePath targetPath
    ∇

    ∇ r←PublishPackage Arg;url;url_;qdmx;statusCode;list;source;msg;rc;zipFilename;firstFlag;packageID;policy;f1;f2
      r←''
      (source url)←Arg.(_1 _2)
      :If (,'?')≡,url
          :If 0=≢url←SelectRegistry 1
              :Return
          :EndIf
      :EndIf
      :If ~TC.Reg.IsHTTP url
      :AndIf ~TC.Reg.IsFILE url
          'Invalid target'Assert'['∊url
          url←'[',(url~'[]'),']'
      :EndIf
      url_←TC.ReplaceRegistryAlias url
      ('"',url,'" is not a Registry')Assert 0<≢url_
     
      :If TC.F.IsDir source
          ('"',source,'" does not contain a Tatin package')Assert TC.F.IsFile source,'/',TC.CFG_Name
      :Else
          ('"',source,'" is not a ZIP file')Assert'.zip'≡⎕C ¯4↑source
      :EndIf
      firstFlag←1
      f1←'none'≡⎕C policy←TC.GetDeletePolicy url_
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
          :If 0=∆YesOrNo msg
              ⎕←'Publishing cancelled'
              :Return
          :EndIf
      :EndIf
     ∆Again:
      :Trap 998
          (rc msg zipFilename)←TC.PublishPackage source url
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
                  qdmx.EM ⎕SIGNAL 998
              :EndSelect
          :Else
              :If firstFlag
              :AndIf 'Server: The package has already been published'{⍺≡(≢⍺)↑⍵}qdmx.EM
              :AndIf 'Any'≡⎕SE.Tatin.GetDeletePolicy url_
                  packageID←2⊃⎕NPARTS source
              :AndIf ∆YesOrNo packageID,' already published on ',url_,'; overwrite?'
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

    ∇ r←UninstallPackage Arg;path;packageID;msg
    ⍝ Attempt to un-install the top-level package `packageID` from the folder `path`
      (path packageID)←Arg.(_1 _2)
      'No path specified'Assert 0≢path
      :If 0≡packageID
          packageID←''
      :EndIf
      (r msg)←TC.UnInstallPackage path packageID
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

    ∇ r←ListTags Arg;parms;registry
      r←''
      parms←⎕NS''
      parms.tags←''
      :If 0≡registry←Arg._1
          →(⍬≡registry←SelectRegistry 0)/0
      :Else
          registry,←(~(¯1↑registry)∊'/\')/'/'
      :EndIf
      :If 0≢Arg.tags
      :AndIf 0<≢Arg.tags
          parms.tags←Arg.tags
      :EndIf
      r←⍪parms TC.ListTags registry
    ∇

    ∇ r←ListVersions Arg;qdmx;dateFlag
      dateFlag←Arg.Switch'date'
      :Trap 998
          :If dateFlag
              r←dateFlag TC.ListVersions Arg._1
              r[;2]←TC.Reg.FormatFloatDate¨r[;2]
          :Else
              r←⍪TC.ListVersions Arg._1
          :EndIf
      :Else
          qdmx←⎕DMX
          :If 0=≢qdmx.EM
              ('Not found: ',Arg._1)⎕SIGNAL 998
          :Else
              qdmx.EM ⎕SIGNAL 998
          :EndIf
      :EndTrap
    ∇

    ∇ r←Documentation Arg
      r←0 0⍴⍬
      {}⎕SE._Tatin.APLTreeUtils2.GoToWebPage'https://tatin.dev/v1/documentation'   ⍝TODO⍝
    ∇

    ∇ r←LoadPackage Arg;targetSpace;identifier;saveIn
      (identifier targetSpace)←Arg.(_1 _2)
      :If 0≡targetSpace
          targetSpace←,'#'
      :EndIf
      :If ~(⊂,1 ⎕C targetSpace)∊,¨'#' '⎕SE'
          '"targetSpace" is not a valid APL name'Assert ¯1≠⎕NC targetSpace
      :EndIf
      saveIn←⍎{⍵↑⍨¯1+⍵⍳'.'}targetSpace
      :If ~(⊂1 ⎕C targetSpace)∊,¨'#' '⎕SE'
      :AndIf 0=saveIn.⎕NC'targetSpace'
          '"targetSpace" does not specify a fully qualified namespace in either # or ⎕SE'Assert'.'∊targetSpace
          ((1+≢saveIn)↓targetSpace)saveIn.⎕NS''
      :EndIf
      r←Arg.nobetas TC.LoadPackage identifier targetSpace
    ∇

    ∇ r←PackageConfig Arg;path;ns;newFlag;origData;success;newData;msg;qdmx;filename;what;uri;list;flag;data
      r←⍬
      :If (,0)≡,what←Arg._1
          what←TC.F.PWD
      :ElseIf '['∊what
          what←TC.ReplaceRegistryAlias what
      :EndIf
      :If TC.Reg.IsHTTP what
          r←TC.ReadPackageConfigFile_ what
      :Else
          path←what
          filename←path,'/',TC.CFG_Name
          :If Arg.delete
              'File not found'Assert TC.F.IsFile filename
              msg←'Sure you want to delete "',filename,'" ?'
              :If Arg.quiet
              :OrIf 0 ∆YesOrNo msg
                  TC.F.DeleteFile filename
              :EndIf
          :Else
              :If 0=TC.F.IsDir path
                  :If Arg.quiet
                  :OrIf ∆YesOrNo'The directory does not exist yet. Would you like to create it?'
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
                  :AndIf 0=1 ∆YesOrNo'There is no file ',TC.CFG_Name,' yet; would you like to create it?'
                      ⎕←'Cancelled'
                      :Return
                  :EndIf
                  ns←TC.InitPackageConfig ⍬
                  newFlag←1
              :EndIf
              :If Arg.edit∨newFlag
                  data←origData←TC.Reg.JSON ns
                  :Repeat
                      (success newData)←(CheckPackageConfigFile EditJson)'PackageConfigFile'data path
                      flag←1
                      :If success
                          :If 0<≢∊newData
                          :AndIf newFlag∨newData≢origData
                              ns←⎕JSON⍠('Dialect' 'JSON5')⊣newData
                              :Trap 998
                                  1 TC.WritePackageConfigFile path ns
                              :Else
                                  qdmx←⎕DMX
                                  ⎕←qdmx.EM
                                  :If 0=1 ∆YesOrNo'Would you like to try to fix the problem in the editor? (n=abandon changes)'
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
          :OrIf 0 ∆YesOrNo msg
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

    ∇ r←InstallPackage Arg;identifier;installFolder
      r←''
      (identifier installFolder)←Arg.(_1 _2)
      :If 0≡installFolder
          :If Arg.quiet
          :OrIf ∆YesOrNo'No install folder was provided; install into ',TC.F.PWD,' ?'
              installFolder←TC.F.PWD
          :Else
              :Return
          :EndIf
      :EndIf
      'Install folder is invalid'Assert~(⊂,1 ⎕C installFolder)∊,¨'#' '⎕SE'
      :If './'≢2⍴installFolder
      :AndIf '/'≠1⍴installFolder
      :AndIf ~':'∊installFolder
          :If '['=1⍴installFolder
          :AndIf ']'∊installFolder
              installFolder←TranslateCiderAlias installFolder
          :Else
              installFolder←TC.F.PWD,'/',installFolder
          :EndIf
      :EndIf
      :If ~TC.F.IsDir installFolder
          :If Arg.quiet
          :OrIf 1 ∆YesOrNo'Install folder <',installFolder,'> does not yet exist; create?'
              'Create!'TC.F.CheckPath installFolder
          :EndIf
      :EndIf
      ('Does not exist: ',installFolder)Assert ⎕NEXISTS installFolder
      r←TC.InstallPackage identifier installFolder
    ∇
    
    ∇ installFolder←TranslateCiderAlias installFolder;ind;alias;list
      ind←installFolder⍳']'
      alias←(ind↑installFolder)~'[]'
      installFolder←ind↓installFolder
      list←⎕SE.Cider.ListOpenProjects 1
      'No Cider projects found'Assert 0<≢list
      ('Alias "',alias,'" does not define an open Cider project')Assert(⊂alias)∊list[;4]
      installFolder←(AddSlash 2⊃list[list[;4]⍳⊂alias;]),installFolder
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
              :AndIf 1 ∆YesOrNo'Do you want to save your changes to disk?'
                  (⊂new)⎕NPUT filename 1
              :AndIf 1 ∆YesOrNo'Saved! Would you like to refresh the user settings in ⎕SE?'
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
                  flag←~∆YesOrNo msg
              :Else
                  (msg json)←CheckFns json path
                  :If 0<≢msg
                      flag←~1 ∆YesOrNo msg,CR,'Want to try fixing the problem (n=abandon ALL changes) ?'
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
              txt{TC.A.(dlb dtb)⍵}¨txt
          :AndIf 0<≢(∊txt)~' '
              :If 0<≢msg←CheckFns txt
                  ⎕←msg
                  flag←~∆YesOrNo'Woulde you like to fix the problem? (N=abandon changes)'
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
          :Case ⎕C'LoadTatin'
              r,←⊂'Load the Tatin client into ⎕SE (if it''s not already there) and initializes it.'
              r,←'' '  ]Tatin.LoadTatin'
          :Case ⎕C'ListRegistries'
              r,←⊂'List URL, alias, priority and port of all Registries as defined in the user settings.'
              r,←'' '  ]Tatin.ListRegistries [-full]'
          :Case ⎕C'ListPackages'
              r,←⊂'List all packages in the Registry or install folder passed as argument'
              r,←'' '  ]Tatin.ListPackages <URL|[Alias|<path/to/registry>|<install-folder>]> [-group=] [-tags=] [-date] [-info_url] [-since={YYYYMMDD|YYYY-MM-DD}] [-noaggr]'
          :Case ⎕C'LoadPackage'
              r,←⊂'Load the specified package and all its dependencies into the workspace.'
              r,←'' '  ]Tatin.LoadPackage <packageID|package-URL|Zip-file> [<target namespace>]'
          :Case ⎕C'InstallPackage'
              r,←⊂'Install the given package and all its dependencies into the given folder.'
              r,←'' '  ]Tatin.InstallPackage <packageID|package-URL|Zip-file> <install-path> [-quiet]'
          :Case ⎕C'LoadDependencies'
              r,←⊂'Load all packages defined in a file apl-dependencies.txt.'
              r,←'' '  ]Tatin.LoadDependencies <package-folder> [<parent-namespace>] [-overwrite]'
          :Case ⎕C'UserSettings'
              r,←⊂'Print the user settings found in the config file to ⎕SE and allows manipulation via flags'
              r,←'' '  ]Tatin.UserSettings [-apikey] [-edit] [-refresh]'
          :Case ⎕C'PackageConfig'
              r,←⊂'Manage a package config file: fetch, create, edit or delete it.'
              r,←'' '  ]Tatin.PackageConfig <package-URL|package-folder> [-edit] [-delete]'
          :Case ⎕C'UninstallPackage'
              r,←⊂'Uninstalls a given package and possibly all its dependencies.'
              r,←'' '  ]Tatin.UninstallPackage <package-folder> [<package-ID|package-alias>]'
          :Case ⎕C'PackageDependencies'
              r,←⊂'Return the contents of a file "apl-dependencies.txt".'
              r,←'' '  ]Tatin.PackageDependencies <package-path> [-edit] [-delete] [-quiet]'
          :Case ⎕C'Pack'
              r,←⊂'Create a ZIP file that is a package from the directory.'
              r,←'' '  ]Tatin.Pack [<package-folder>] [<target-folder>]'
          :Case ⎕C'PublishPackage'
              r,←⊂'Publish a package to a particular Tatin Server.'
              r,←'' '  ]Tatin.PublishPackage <package-folder|ZIP-file> <Registry-URL|[Registry-Alias]> [-quiet]'
          :Case ⎕C'ListVersions'
              r,←⊂'List all versions of the given package.'
              r,←'' '  ]Tatin.ListVersions <[Registry-URL|[Registry-Alias|*][<group>]-<name>> [-date]'
          :Case ⎕C'Version'
              r,←⊂'Prints name, version number and version date of Tatin to the session.'
              r,←'' '  ]Tatin.Version'
          :Case ⎕C'ListTags'
              r,←⊂'List all unique tags as defined in all packages on a server, sorted alphabetically.'
              r,←'' '  ]Tatin.ListTags [<Registry-URL>] [-tags=]'
          :Case ⎕C'Init'
              r,←⊂'(Re-)Establishe the user settings in ⎕SE.'
              r,←'' '  ]Tatin.Init [<config-folder>]'
          :Case ⎕C'CheckForLaterVersion'
              r,←⊂'Check whether for the installed packages a later versions are available.'
              r,←'' '  ]Tatin.CheckForLaterVersion <install-folder> [-major] [-dependencies]'
          :Case ⎕C'DeletePackage'
              r,←⊂'Delete a given package.'
              r,←'' '  ]Tatin.DeletePackage <([Registry-alias|Registry-URL|file://package-folder)package-ID)>'
          :Case ⎕C'GetDeletePolicy'
              r,←⊂'Request which "Delete" policy is operated by a server.'
              r,←'' '  ]Tatin.GetDeletePolicy [<Registry-URL>]'
          :Case ⎕C'Documentation'
              r,←⊂'Put https://tatin.dev/v1/documentation into the default browser'
              r,←'' '  ]Tatin.Documentation'
          :Case ⎕C'ReinstallDependencies'
              r,←⊂'Reinstall all packages defined in a folder from scratch.'
              r,←'' '  ]Tatin.ReinstallDependencies <install-folder> [Registry-URL|Registry-alias] [-force] [-dry] [-nobeta] [-update]'
          :Case ⎕C'Ping'
              r,←⊂'Try to contact the specified or all known Tatin servers'
              r,←'' '  ]Tatin.Ping [server-url]'
          :EndSelect
          :If 'Version'≢Cmd
              r,←''(']Tatin.',Cmd,' -?? ⍝ Enter this for more information ')
          :EndIf
      :Case 1
          :Select ⎕C Cmd
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
              r,←⊂'List URL, alias, priority and port of all Registries as defined in the user settings.'
              r,←⊂'The result is ordered by priority: the first one is scanned first etc.'
              r,←⊂'Note that Registries with a priority of 0  will not participate in a scan of Registries.'
              r,←⊂''
              r,←⊂'-full By default all data but the API keys are listed. Specify -full if you want the'
              r,←⊂'      API keys to be listed as well.'
          :Case ⎕C'ListPackages'
              r,←⊂'List all packages in the Registry or install folder specified. If no argument was specified'
              r,←⊂'then the user will be prompted for the Registry, except when there is just one anyway.'
              r,←⊂''
              r,←⊂'It does not matter whether you specify / or \ in a path, or whether it has or has not'
              r,←⊂'a trailing separator: Tatin is taking care of that.'
              r,←⊂''
              r,←⊂'In case an install folder was specified (rather than a registry) flags are ignored'
              r,←⊂'In this case two columns are returned: package name and a Boolean indicating principal'
              r,←⊂'packages with a 1.'
              r,←⊂''
              r,←⊂'By default all packages are listed. You can influence the output in several ways:'
              r,←⊂'-group={foo}  restricts the list to packages with the given group name.'
              r,←⊂'-tags=foo,goo restricts the output to packages that carry the tags "foo" & "goo".'
              r,←⊂'-date         adds the publishing date to the output. -noaggr is set to 1 then.'
              r,←⊂'-info_url     adds the URL saved in the package config file.'
              r,←⊂'-since        Must be a date either as YYYYMMDD or YYYY-MM-DD when specified.'
              r,←⊂'              Only packages published on that date or after are listed then.'
              r,←⊂'              Implies -date and ignores -noaggr.'
              r,←⊂'-noaggr       By default the output is aggregated. -noaggr prevents that.'
          :Case ⎕C'LoadPackage'
              r,←⊂'Load the specified package and all its dependencies into the workspace.'
              r,←⊂''
              r,←⊂'A) First argument:'
              r,←HelpOnPackageID ⍬
              r,←⊂''
              r,←⊂'B) Second (optional) argument: target namespace (defaults to #)'
              r,←⊂'Must be the fully qualified name of a namespace the package will be loaded into.'
              r,←⊂'May be # or ⎕SE or a sub-namespace of any level'
              r,←⊂''
              r,←⊂'Returns the fully qualified name of the package established in the target space'
          :Case ⎕C'InstallPackage'
              r,←⊂'Install the given package and all its dependencies into the given folder.'
              r,←⊂'If the package is already installed, it (as well as any dependencies) will be'
              r,←⊂'installed again from scratch.'
              r,←⊂'Requires two arguments:'
              r,←⊂''
              r,←⊂'A) First argument:'
              r,←HelpOnPackageID ⍬
              r,←⊂''
              r,←⊂'B) Second argument'
              r,←⊂'The second argument must be the path to a folder into which the packages are'
              r,←⊂'going to be installed.'
              r,←⊂''
              r,←⊂'-quiet: Useful for test cases: it prevents Tatin from interrogating the user'
          :Case ⎕C'LoadDependencies'
              r,←⊂'Load all packages defined in a file apl-dependencies.txt.'
              r,←⊂''
              r,←⊂'Takes up to two arguments:'
              r,←⊂'[1] A folder into which one or more packages have been installed'
              r,←⊂'[2] Optional: a namespace into which the packages are going to be loaded; default is #'
              r,←⊂''
              r,←⊂'-overwrite: By default a package is not loaded if it already exists. You can enforce the'
              r,←⊂'            load by specifying the -overwrite flag.'
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
              r,←⊂'The argument, if specified, may be a URL or a path.'
              r,←⊂' * In case of a URL the package config file is returned as JSON.'
              r,←⊂'   Specifying any of the options has no effect then.'
              r,←⊂' * In case of a path it must point to a folder that contains a Tatin package.'
              r,←⊂'   The contents of the file "',TC.CFG_Name,'" in that folder is returned.'
              r,←⊂'   In case the file does not yet exist it will be created.'
              r,←⊂''
              r,←⊂'In case no argument is specified the command tries to find a package config file in'
              r,←⊂'the current directory.'
              r,←⊂''
              r,←⊂'-edit   You may edit the file by specifying the -edit flag.'
              r,←⊂'-delete In case you want to delete the file specify the -delete flag.'
              r,←⊂''
              r,←⊂'In case of success a text vector (with NLs) is returned, otherwise an empty vector.'
          :Case ⎕C'UninstallPackage'
              r,←⊂'Uninstall a given package and all its dependencies, but only if those'
              r,←⊂'are neither top-level packages nor required by other packages.'
              r,←⊂'In addition any superfluous packages like outdated versions) are removed, too.'
              r,←⊂'If no package is specified only superfluous packages, if any, will be uninstalled.'
              r,←⊂''
              r,←⊂'Requires at least one argument:'
              r,←⊂' * Path to a folder with installed packages'
              r,←⊂' * Optionally a package identifier;  this can be one of:'
              r,←⊂'   * Name of the package'
              r,←⊂'   * Alias and name of the package'
              r,←⊂'   * Just an alias; post- or prefix with a "@" in order to mark it as such'
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
          :Case ⎕C'Pack'
              r,←⊂'Create a ZIP file from the directory ⍵[1] that is a package, and saves it in ⍵[2].'
              r,←⊂'Requires directory ⍵[1] to host a file "',TC.CFG_Name,'" defining the package.'
              r,←⊂''
              r,←⊂' * If ⍵[2] is not specified the pack file will be created in ⍵[1], but the user will be prompted.'
              r,←⊂' * If ⍵[1] is not specified it will act on the current directory, but the user will be prompted.'
          :Case ⎕C'PublishPackage'
              r,←⊂'Publish a package to a particular Tatin Server.'
              r,←⊂'Such a package can be one of:'
              r,←⊂' * ZIP file, typically created by calling ]Tatin.Pack'
              r,←⊂' * Folder that contains everything that defines a package; in this case the required ZIP is'
              r,←⊂'   created by "PublishPackage" itself.'
              r,←⊂''
              r,←⊂'Requires two arguments:'
              r,←⊂' * Path to ZIP file or package folder'
              r,←⊂' * URL or alias of a Registry Server or a "?"; you may or may not embrace it with []'
              r,←⊂''
              r,←⊂'The name of the resulting package is extracted from the ZIP file which therefore must conform'
              r,←⊂'to the Tatin rules.'
              r,←⊂''
              r,←⊂'Tatin checks the "delete" policy of the server. If the package cannot be deleted then the user'
              r,←⊂'must confirm that she really wants to publish to that particular server.'
              r,←⊂''
              r,←⊂'-quiet: useful for test cases; it prevents Tatin from interrogating the user'
          :Case ⎕C'ListVersions'
              r,←⊂'List all versions of the given package. You may specify the package in two different ways:'
              r,←⊂' * [registry]{group}-{package}'
              r,←⊂' * [registry]{package}'
              r,←⊂''
              r,←⊂'Lacking a group does not make a difference if the given package exists only in one group anyway.'
              r,←⊂'If it exists in more than one group then all of them are listed.'
              r,←⊂''
              r,←⊂'The special syntax [*] will return a list of all versions of a package from all Registries:'
              r,←⊂']Tatin.ListVersions [*]{group}-{name}'
              r,←⊂'or'
              r,←⊂']Tatin.ListVersions [*]{name}'
              r,←⊂''
              r,←⊂'If version precedence cannot be established from the version numbers alone (often a problem with'
              r,←⊂'beta versions) then the publishing date is taken into account.'
              r,←⊂''
              r,←⊂'-date Adds the publishing date to the report.'
          :Case ⎕C'Version'
              r,←⊂'Prints name, version number and version date of Tatin to the session.'
              r,←⊂''
              r,←⊂' * Specify a URL or an alias if you are after the version number of a Tatin server'
              r,←⊂' * Specify * if you are after the version numbers of all Tatin servers'
          :Case ⎕C'ListTags'
              r,←⊂'List all unique tags as defined in all packages on a server, sorted alphabetically.'
              r,←⊂''
              r,←⊂'If no Registry is specified as argument the user will be prompted unless there is only one'
              r,←⊂'Registry anyway.'
              r,←⊂''
              r,←⊂'You can specify one or more tags like -tags=foo,goo'
              r,←⊂'In that case all tags are listed from packages that carry both "foo" & "goo".'
              r,←⊂''
              r,←⊂'For details how tags are search refer to the documentation.'
          :Case ⎕C'Init'
              r,←⊂'(Re-)Establishe the user settings in ⎕SE. Call this in case the user settings got changed on file'
              r,←⊂'and you want to incorporate the changes in the current session.'
              r,←⊂''
              r,←⊂'Without an argument Init processes the default user settings file.'
              r,←⊂'Instead you may specify a folder that contains a file tatin-client.json.'
          :Case ⎕C'CheckForLaterVersion'
              r,←⊂'Check whether for the installed packages later versions are available.'
              r,←⊂'Takes a folder with a file "apl-buildlist.json" as argument.'
              r,←⊂'Scans all known registries with a priority greater than 0 for a later version.'
              r,←⊂''
              r,←⊂'Returns a matrix with four columns for all packages found:'
              r,←⊂'[;1] Currently installed packged IS'
              r,←⊂'[;2] package ID of the latest version found or something like "no response" or "not found"'
              r,←⊂'[;3] URL of the Registry the later version was found'
              r,←⊂'[;4] ! for a later version'
              r,←⊂''
              r,←⊂'-major        by default later MAJOR versions are ignored, but this default behaviour can be'
              r,←⊂'              changed by specifying -major: then only later major versions are reported.'
              r,←⊂''
              r,←⊂'-dependencies by default only principal packages are checked.'
              r,←⊂'              You may include dependencies by specifying this flag.'
          :Case ⎕C'DeletePackage'
              r,←⊂'Delete a given package.'
              r,←⊂''
              r,←⊂'Takes one of:'
              r,←⊂' * URL specifying a Tatin server, followed by a full package ID'
              r,←⊂' * [alias] specifying a Tatin server, followed by a full package ID'
              r,←⊂' * Folder hosting a package; must start with file://'
              r,←⊂'   The folder must contain a file apl-package.json, otherwise an error is thrown'
              r,←⊂''
              r,←⊂'Whether a package can be deleted or not depends on the delete policy operated by a given server.'
              r,←⊂'A server may allow...'
              r,←⊂' * no deletion at all'
              r,←⊂' * deletion of beta versions only'
              r,←⊂' * everything'
          :Case ⎕C'GetDeletePolicy'
              r,←⊂'Request which "Delete" policy is operated by a server.'
              r,←⊂'Return one of "None", "Any", "JustBetas":'
              r,←⊂' * "None" means a package, once published, cannot be deleted'
              r,←⊂' * "Any" means any package can be deleted'
              r,←⊂' * "JustBetas" means that only beta versions can be deleted'
              r,←⊂'If no server is specified the user will be prompted, unless there is just one server anyway.'
          :Case ⎕C'Documentation'
              r,←⊂'Put https://tatin.dev/v1/documentation into the default browser'
          :Case ⎕C'ReinstallDependencies'
              r,←⊂'Reinstall all packages (principals as well as dependencies) from scratch.'
              r,←⊂'Takes a folder as mandatory argument. That folder must host a file apl-dependencies.txt.'
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
              r,←⊂'For dependencies, all registries with a priority greater than 0 are scanned in aby case.'
              r,←⊂''
              r,←⊂'-force   Prevents user confirmation and reporting to the session.'
              r,←⊂'-dry     Report what would be done without actually doing it.'
              r,←⊂'-nobetas By default betas are included; suppress with -nobetas.'
              r,←⊂'-update  By default ReinstallDependencies does not install later versions.'
              r,←⊂'         You may change this by specifying this flag.'
          :Case ⎕C'Ping'
              r,←⊂'Try to contact one or more Tatin servers.'
              r,←⊂''
              r,←⊂' * Optionally you may specify a server URL as an argument.'
              r,←⊂' * You can also specify just a "?"; then a list with all known Servers will be provided.'
              r,←⊂'   You may then select one or multiple of them.'
              r,←⊂' * If no argument is provided at all then all defined Servers are contacted.'
              r,←⊂' * In case the path to a folder is passed as ⍵ a 1 is returned in case the folder exists.'
              r,←⊂''
              r,←⊂'In any case a matrix with two columns is returned:'
              r,←⊂' [;1] is the Server URL'
              r,←⊂' [;2] is a Boolean, a 1 means that the server responded'
          :Else
              r←'Unknown command: ',Cmd
          :EndSelect
          :If (⊂⎕C Cmd)∊⎕C¨'LoadPackage' 'InstallPackage' 'DeletePackage' 'ReinstallDependencies' 'Ping'
          :AndIf (⎕C∊r)≢⎕C'Unknown command: ',Cmd
              r,←''(']',Cmd,' -??? ⍝ Enter this for examples ')
          :EndIf
      :Case 2
          :Select ⎕C Cmd
          :Case ⎕C'LoadTatin'
          :Case ⎕C'ListRegistries'
          :Case ⎕C'ListPackages'
          :Case ⎕C'LoadPackage'
              r,←⊂'Examples:'
              r,←⊂'  ]Tatin.LoadPackage group-name-2.0.0                ⍝ Just full package ID without Registry'
              r,←⊂'  ]Tatin.LoadPackage [tatin]group-name-1.0           ⍝ Alias & package ID without patch no.'
              r,←⊂'  ]Tatin.LoadPackage [tatin]group-name-1             ⍝ Without patch and minor no.'
              r,←⊂'  ]Tatin.LoadPackage [tatin]group-name               ⍝ With any version information'
              r,←⊂'  ]Tatin.LoadPackage [tatin]/group-name-1.0.0        ⍝ With "/"'
              r,←⊂'  ]Tatin.LoadPackage [tatin]group-name-1.0.0         ⍝ Without "/"'
              r,←⊂'  ]Tatin.LoadPackage [tatin]name #                   ⍝ With target namespace'
              r,←⊂'  ]Tatin.LoadPackage [tatin]A@name #                 ⍝ With package alias'
              r,←⊂'  ]Tatin.LoadPackage name #                          ⍝ No Registry and no group'
              r,←⊂'  ]Tatin.LoadPackage A@name                          ⍝ No Registry and no group but alias'
              r,←⊂'  ]Tatin.LoadPackage A@name #.Foo.Goo                ⍝ With target namespace'
              r,←⊂'  ]Tatin.LoadPackage file:///path/group-name-1.0.0/  ⍝ Local Registry'
          :Case ⎕C'InstallPackage'
              r,←⊂'Examples:'
              r,←⊂'  ]Tatin.InstallPackage [tatin]/group-name-1.0.0 /path           ⍝ Alias & package ID with "/"'
              r,←⊂'  ]Tatin.InstallPackage [tatin]group-name-1.0.0 /path            ⍝ Alias & package ID without "/"'
              r,←⊂'  ]Tatin.InstallPackage [tatin]group-name-1.0 /path              ⍝ No patch no'
              r,←⊂'  ]Tatin.InstallPackage [tatin]group-name-1 /path                ⍝ Neither patch nor minor no.'
              r,←⊂'  ]Tatin.InstallPackage [tatin]group-name /path                  ⍝ No version information at all'
              r,←⊂'  ]Tatin.InstallPackage [tatin]name /path                        ⍝ No group and no version information'
              r,←⊂'  ]Tatin.InstallPackage [tatin]A@name /path                      ⍝ Registry alias and package alias'
              r,←⊂'  ]Tatin.InstallPackage group-name-2.0.0 /path                   ⍝ Just a full package ID'
              r,←⊂'  ]Tatin.InstallPackage name /path                               ⍝ Just a package name'
              r,←⊂'  ]Tatin.InstallPackage A@name /path                             ⍝ Just a package name & a package alias'
              r,←⊂'  ]Tatin.InstallPackage file:///path/group-name-1.0.0/ /install/ ⍝ Package in a local Registry'
          :Case ⎕C'LoadDependencies'
          :Case ⎕C'UserSettings'
          :Case ⎕C'PackageConfig'
          :Case ⎕C'UninstallPackage'
          :Case ⎕C'PackageDependencies'
          :Case ⎕C'Pack'
          :Case ⎕C'PublishPackage'
          :Case ⎕C'ListVersions'
          :Case ⎕C'Version'
          :Case ⎕C'ListTags'
          :Case ⎕C'Init'
          :Case ⎕C'CheckForLaterVersion'
          :Case ⎕C'DeletePackage'
              r,←⊂'Examples:'
              r,←⊂'  ]Tatin.DeletePackage https:/tatin.dev/group-name-1.0.0 ⍝ Server URL & package ID'
              r,←⊂'  ]Tatin.DeletePackage [test-tatin]group-name-1.0.0      ⍝ Server alias & package ID'
              r,←⊂'  ]Tatin.DeletePackage C:\My\Registry\group-name-1.0.0   ⍝ Local package'
          :Case ⎕C'GetDeletePolicy'
              r←'Not ready yet'
          :Case ⎕C'Documentation'
          :Case ⎕C'ReinstallDependencies'
              r,←⊂'Examples:'
              r,←⊂'  ]Tatin.ReinstallDependencies /path/'
              r,←⊂'  ]Tatin.ReinstallDependencies /path/ [tatin]'
              r,←⊂'  ]Tatin.ReinstallDependencies /path/ [tatin] -nobetas'
              r,←⊂'  ]Tatin.ReinstallDependencies /path/ [tatin] -nobetas -dry'
              r,←⊂'  ]Tatin.ReinstallDependencies /path/ [tatin] -nobetas -force'
              r,←⊂'  ]Tatin.ReinstallDependencies /path/ [tatin] -nobetas -force -update'
          :Case ⎕C'Ping'
              r,←⊂'Examples:'
              r,←⊂'  ]Tatin.Ping'
              r,←⊂'  ]Tatin.Ping ?'
              r,←⊂'  ]Tatin.Ping [tatin]'
              r,←⊂'  ]Tatin.Ping https://tatin.dev'
              r,←⊂'  ]Tatin.Ping http://tatin.dev   ⍝ This won''t work'
          :Else
              ⍝ Not available then
          :EndSelect
      :EndSelect
    ∇

    ∇ r←HelpOnPackageID dummy
      r←''
      r,←⊂'You may specify an alias for the package in question by putting it to the front'
      r,←⊂'and separate it with an @.'
      r,←⊂''
      r,←⊂'Not that if neither a Registry nor a ZIP file is specified but just a package ID'
      r,←⊂'(partly or fully) then all defined Registries with a priority of greater than 0'
      r,←⊂'will be scanned; the first hit wins.'
      r,←⊂''
      r,←⊂'It may be:'
      r,←⊂' * A full package ID.'
      r,←⊂'   A full package ID has three ingredients: {group}-{name}-{major.minor.patch}.'
      r,←⊂' * You may also specify an incomplete package ID in terms of no patch number, or'
      r,←⊂'   neither minor nor patch number, or no version information at all, and leave'
      r,←⊂'   it to Tatin to establish the latest version itself.'
      r,←⊂' * You may also omit the group. This will fail in case the same package name is'
      r,←⊂'   used in two or more different groups but will succeed otherwise.'
      r,←⊂' * Either a full path or a URL in front of the package ID.'
      r,←⊂''
      r,←⊂'-nobetas: By default beta versions are included. Specify -nobetas to suppress them.'
    ∇

    ∇ yesOrNo←{default}∆YesOrNo question;isOkay;answer;add;dtb;answer2
    ⍝ Ask a simple question and allows just "Yes" or "No" as answers.
    ⍝ You may specify a default via the optional left argument which when specified
    ⍝ rules what happens when the user just presses <enter>.
    ⍝ `default` must be either 1 (yes) or 0 (no).
    ⍝ Note that this function does not work as expected when traced!
      isOkay←0
      default←{0<⎕NC ⍵:⍎⍵ ⋄ ''}'default'
      isOkay←0
      :If ~0∊⍴default
          'Left argument must be a scalar'⎕SIGNAL 998/⍨1≠⍴,default
      :AndIf ~default∊0 1
          'The left argument. if specified, must be a Boolean or empty'⎕SIGNAL 998
      :EndIf
      :If 0=≢default
          add←' (y/n) '
      :Else
          :If default
              add←' (Y/n) '
          :Else
              add←' (y/N) '
          :EndIf
      :EndIf
      :If 1<≡question
          ((⍴question)⊃question)←((⍴question)⊃question),add
          question←⍪question
      :Else
          question←question,add
      :EndIf
      :Repeat
          ⍞←question
          answer←⍞
          :If answer≡question                        ⍝ Did...  (since version 18.0 trailing blanks are not removed anynmore)
          :OrIf (≢answer)=¯1+≢question               ⍝ ..the ...
          :OrIf 0=≢answer                            ⍝ ...user just...
              dtb←{⍵↓⍨-+/∧\' '=⌽⍵}
              answer2←dtb answer
          :OrIf answer2≡((-≢answer2)↑dtb question)   ⍝ ...press <enter>?
              :If 0≠≢default
                  yesOrNo←default
                  isOkay←1
              :EndIf
          :Else
              answer←¯1↑{⍵↓⍨-+/∧\' '=⌽⍵}answer
              :If answer∊'YyNn'
                  isOkay←1
                  yesOrNo←answer∊'Yy'
              :EndIf
          :EndIf
      :Until isOkay
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
      :Trap 998
          cfg2←TC.InitPackageConfig ns
          'name'TC.ValidateName ns.name
          'group'TC.ValidateName ns.group
          {}'api'TC.ValidateName⍣(0<≢ns.api)⊣ns.api
          TC.ValidateVersion ns.version
          ns←TC.ValidateTags ns
          ns←TC.ValidateDescription ns
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
          :If 0<≢ns.info_url
              :If 0=TC.SendHEAD ns.info_url
                  msg←ns.info_url,' did not respond'
                  :Return
              :EndIf
          :EndIf
          json←TC.Reg.JSON ns
      :Else
          msg←⎕DMX.EM
      :EndTrap
    ∇

    Assert←{⍺←'' ⋄ (,1)≡,⍵:r←1 ⋄ ⎕ML←3 ⋄ ⍺ ⎕SIGNAL 1↓(↑∊⍵),998}
    AddHeader←{0=≢⍺:⍺ ⋄(⍵,[0.5]'-'⍴¨⍨≢¨⍵)⍪⍺}
    EnforceSlash←{'/'@(⍸'\'=⍵)⊣⍵}
    IsScripted←{0::1 ⋄0⊣⎕src ⍵}
    ED←{⎕ED⍠('EditName' 'Disallow')⊣⍵}
    IsValidJSON←{0::0 ⋄ 1⊣TC.Reg.JSON ⍵}
    IfAtLeastVersion←{⍵≤{⊃(//)⎕VFI ⍵/⍨2>+\'.'=⍵}2⊃# ⎕WG'APLVersion'}

    ∇ index←{x}Select options;flag;answer;question;value;bool;⎕ML;⎕IO;manyFlag;mustFlag;caption
    ⍝ Presents `options` as a numbered list and allows the user to select either exactly one or multiple ones.\\
    ⍝ One is the default.\\
    ⍝ The optional left argument allows you to specify more options:
    ⍝ * `manyFlag` defaults to 0 (meaning just one item might be selected) or 1, in which case multiple items can be specified.
    ⍝ * `mustFlag` forces the user to select at least one  option.
    ⍝ * `caption` is shown above the options.
    ⍝ `options` must not have more than 999 items.
    ⍝ If the user aborts by entering nothing or a "q" (for "quit") `index will be `⍬`.
      x←{0<⎕NC ⍵:⊆⍎⍵ ⋄ ''}'x'
      (caption manyFlag mustFlag)←x,(⍴,x)↓'' 0 0
      ⎕IO←1 ⋄ ⎕ML←1
      manyFlag←{0<⎕NC ⍵:⍎⍵ ⋄ 0}'manyFlag'
      'Invalid right argument; must be a vector of text vectors.'⎕SIGNAL 998/⍨2≠≡options
      'Right argument has more than 999 items'⎕SIGNAL 998/⍨999<≢options
      flag←0
      :Repeat
          ⎕←{⍵↑'--- ',caption,((0≠≢caption)/' '),⍵⍴'-'}⎕PW-1
          ⎕←⍪{((⊂'. '),¨⍨(⊂3 0)⍕¨⍳⍴⍵),¨⍵}options
          ⎕←''
          question←'Select one ',(manyFlag/'or more '),'item',((manyFlag)/'s'),' '
          question,←((manyFlag∨~mustFlag)/'('),((~mustFlag)/'q=quit'),((manyFlag∧~mustFlag)/', '),(manyFlag/'a=all'),((manyFlag∨~mustFlag)/')'),' :'
          :If 0<≢answer←⍞,0/⍞←question
              answer←(⍴question)↓answer
              :If 1=≢answer
              :AndIf answer∊'Qq',manyFlag/'Aa'
                  :If answer∊'Qq'
                      :If 0=mustFlag
                          index←⍬
                          flag←1
                      :EndIf
                  :Else
                      index←⍳≢options
                      flag←1
                  :EndIf
              :Else
                  (bool value)←⎕VFI answer
                  :If ∧/bool
                  :AndIf manyFlag∨1=+/bool
                      value←bool/value
                  :AndIf ∧/value∊⍳⍴options
                      index←value
                      flag←0≠≢index
                  :EndIf
              :EndIf
          :EndIf
      :Until flag
      index←{1<≢⍵:⍵ ⋄ ⊃⍵}⍣(⍬≢index)⊣index
    ∇

    ∇ r←GetListOfRegistriesForSelection type
      r←TC.ListRegistries type
      r[;2]←{0=≢⍵:'' ⋄ '[',⍵,']'}¨r[;2]
    ∇

    ∇ registry←{all}SelectRegistry type;row;list
      all←{0<⎕NC ⍵:⍎⍵ ⋄ 0}'all'
      :If 1=≢list←GetListOfRegistriesForSelection type
          registry←1⊃list[1;]
      :Else
          :If ⍬≡row←'Select Tatin Registry'all Select↓⎕FMT⌽list[;1 2]
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
                  :If ~1 ∆YesOrNo'The JSON is invalid; would you like to edit it again? ("N"=drop out without change)'
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

:EndNamespace
