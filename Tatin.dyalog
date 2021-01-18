:Namespace Tatin
⍝ The ]Tatin user commands for managing packages.\\
⍝ * 0.13.1 - 2021-01-10
⍝   * LoadPackage's help page improved.
⍝ * 0.13.0 - 2021-01-02
⍝   * Some minor improvements
⍝ * 0.12.0 - 2020-12-15
⍝   * New option -noaggr aded to ListPackages
⍝ * 0.11.0 - 2020-12-09
⍝   * `ListPackages` now allows call without an argument. A list of registries is presented then for user selection.
⍝ * 0.10.1 - 2020-11-06
⍝   * Typos in help fixed
⍝   * Help page for `ListVersions` added
⍝ * 0.10.0 - 2020-08-28
⍝   * Method `UninstallPackage` added
⍝ * 0.9.0 - 2020-08-20
⍝   * ListRegistry now accepts a flag -all
⍝ * 0.8.2 - 2020-08-18
⍝   * `ListPackages` throws an error in case the -tags keyword was set but it is not an HTTP request
⍝ * 0.8.1 - 2020-08-15
⍝   * ]tatin.version fixed.
⍝ * 0.8.0 - 2020-08-15
⍝   * ]tatin.UserSettings simplified.
⍝ * 0.7.0 - 2020-08-09
⍝   * ListPackages now honours the -group and the -tags options
⍝ * 0.6.2 - 2020-08-04
⍝   * `UserSettings` replaces API-keys by stars when printing to the session
⍝   * Internal change: "TC" is now "TC" (Tatin Client)
⍝ * 0.6.1 - 2020-07-28
⍝   * Shows only under 18.0 and better now.
⍝ * 0.6.0 - 2020-07-19

    ⎕IO←1 ⋄ ⎕ML←1

    NM←'tatin'
    RS←'#._tatin' ⍝ target root space for packages
    SupportedExtensions←'.aplc' '.apln' '.apli' '.aplf' '.aplo' '.apla' '.charlist' '.charmat' '.charstring' '.dyalog'
    RegKey←'HKCU\Software\Tatin\ConfigPath'

    ∇ r←List;c
      r←⍬
     
      :If IfAtLeastVersion 18
   ⍝ Name, group, short description and parsing rules
     
          c←⎕NS ⍬
          c.Name←'LoadTatin'
          c.Desc←'Loads the Tatin client into ⎕SE, resulting in ⎕SE.Tatin, and initializes it'
          c.Parse←'1s -force'
          r,←c
     
          c←⎕NS ⍬
          c.Name←'ListRegistries'
          c.Desc←'Lists all registries defined in the user settings'
          c.Parse←'0 -raw -all'
          r,←c
     
          c←⎕NS ⍬
          c.Name←'ListPackages'
          c.Desc←'Lists all packages in the Registry specified in the argument'
          c.Parse←'1s -raw -group= -tags= -noaggr'
          r,←c
     
          c←⎕NS ⍬
          c.Name←'LoadPackage'
          c.Desc←'Load the package specified in the argument and all dependencies into the WS'
          c.Parse←'2'
          r,←c
     
          c←⎕NS ⍬
          c.Name←'ListVersions'
          c.Desc←'Lists all versions of the specified package'
          c.Parse←'1'
          r,←c
     
          c←⎕NS ⍬
          c.Name←'InstallPackage'
          c.Desc←'Install a package and all its dependencies into a given folder'
          c.Parse←'2 -quiet'
          r,←c
     
          c←⎕NS ⍬
          c.Name←'LoadDependencies'
          c.Desc←'Takes a folder with installed packages and loads all of them'
          c.Parse←'2'
          r,←c
     
          c←⎕NS ⍬
          c.Name←'UserSettings'
          c.Desc←'The user settings and the fully qualified filenanme are printed to ⎕SE as JSON'
          c.Parse←''
          r,←c
     
          c←⎕NS ⍬
          c.Name←'PackageConfig'
          c.Desc←'Retrieve (HTTP) or create and/or edit a package config file for a specific package'
          c.Parse←'1 -delete -edit -quiet'
          r,←c
     
          c←⎕NS ⍬
          c.Name←'PackageDependencies'
          c.Desc←'Create and/or edit a package dependency file for a specific folder'
          c.Parse←'1 -delete -edit -quiet'
          r,←c
     
          c←⎕NS ⍬
          c.Name←'Pack'
          c.Desc←'Packs (zips) all required files found in ⍵[1] into the folder ⍵[2]'
          c.Parse←'2'
          r,←c
     
          c←⎕NS ⍬
          c.Name←'Publish'
          c.Desc←'Publish a package (ZIP file) to a particular Registry'
          c.Parse←'2 -quiet'
          r,←c
     
          c←⎕NS ⍬
          c.Name←'Version'
          c.Desc←'Prints name, version number and version date of the client to the session'
          c.Parse←''
          r,←c
     
          c←⎕NS ⍬
          c.Name←'ListTags'
          c.Desc←'Lists all tags used in all packages/'
          c.Parse←'1s -tags='
          r,←c
     
          c←⎕NS ⍬
          c.Name←'UninstallPackage'
          c.Desc←'Uninstalls a package and its dependencies'
          c.Parse←'2'
          r,←c
     
          r.Group←⊂NM
     
      :EndIf
     
    ∇

    ∇ {r}←Run(Cmd Input);ns;flag
      :If 0=⎕SE.⎕NC'Tatin'
      :AndIf 'loadtatin'≢⎕C Cmd
          flag←LoadTatin''
      :EndIf
      :If 'loadtatin'≡⎕C Cmd
          Input.force LoadTatin(1+0<≢Input._1)⊃''Input._1
          r←''
      :Else
          TC←⎕SE._Tatin.Client
          r←⍎Cmd,' Input'
      :EndIf
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

    ∇ r←Version
      r←TC.Reg.Version
    ∇

    ∇ {r}←LoadTatin_ forceLoad;filename
      r←1
      filename←(1⊃⎕NPARTS ##.SourceFile),'Tatin/Client.dws'
      :If 0∊⊃∘⎕SE.⎕NC¨'Tatin' '_Tatin'
      :OrIf forceLoad
          ('Workspace not found: ',filename)⎕SIGNAL 11/⍨0=⎕NEXISTS filename
          ⎕SE.⎕EX¨'_Tatin' 'Tatin'
          '_Tatin'⎕SE.⎕CY filename
      :EndIf
      TC←⎕SE._Tatin.Client
    ∇

    ∇ r←ListPackages Arg;registry;parms;caption;width
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
      r←⍪parms TC.ListPackages registry
      :If 0=Arg.raw
          :If 0=≢r
              r←'No packages found'
          :Else
              r(AddHeader)←'Group & Name' '≢ major versions'
              r←⎕FMT r
              caption←' *** Packages from ',registry
              width←(2⊃⍴r)⌈≢caption
              r←(width↑caption),[1]width↑[2]r
          :EndIf
      :EndIf
    ∇

    ∇ r←LoadDependencies Arg;installFolder;f1;f2;targetSpace;saveIn
      installFolder←Arg._1
      targetSpace←Arg._2
      installFolder←'apl-dependencies.txt'{⍵↓⍨(-≢⍺)×⍺≡(-≢⍺)↑⍵}installFolder
      f1←TC.F.IsDir installFolder
      f2←(TC.F.IsFile installFolder)∧'.zip'≡⎕C ¯4↑installFolder
      '⍵[1] is neither a folder nor a ZIP file'Assert f1∨f2
      '"targetSpace" must specify a fully qualified sub-namespace in # or ⎕SE'Assert'.'∊targetSpace
      '"targetSpace" is not a valid APL name'Assert ¯1≠⎕NC targetSpace
      saveIn←⍎{⍵↑⍨¯1+⍵⍳'.'}targetSpace
      ({⍵↓⍨⍵⍳'.'}targetSpace)saveIn.⎕NS''
      :If 0=saveIn.⎕NC'targetSpace'
          '"targetSpace" does not specify a fully qualified namespace in either # or ⎕SE'Assert'.'∊targetSpace
          ((1+≢saveIn)↓targetSpace)saveIn.⎕NS''
      :EndIf
      'Arg[2] must not be scripted'Assert IsScripted⍎targetSpace
      r←TC.LoadDependencies installFolder targetSpace
      r←⍪r
    ∇

    ∇ zipFilename←Pack Arg;filename;sourcePath;targetPath
      (sourcePath targetPath)←Arg.(_1 _2)
      'Source path (⍵[1]) is not a directory'Assert TC.F.IsDir sourcePath
      filename←sourcePath,'/',TC.CFG_NAME
      ('Could not find a file "',TC.CFG_NAME,'" in ',sourcePath)Assert TC.F.IsFile filename
      :If ~(1↑targetPath)∊'./\'
      :AndIf (1↑1↓targetPath)≠':'
          targetPath←sourcePath,'/',targetPath
      :EndIf
      'Target path (⍵[2]) is not a directory'Assert TC.F.IsDir targetPath
      zipFilename←TC.Pack sourcePath targetPath
    ∇

    ∇ r←Publish Arg;zipFilename;url;url_;qdmx;statusCode;list
      r←''
      (zipFilename url)←Arg.(_1 _2)
      :If TC.F.IsDir zipFilename
      :AndIf 0<≢list←⊃TC.F.Dir zipFilename,'/*.zip'
          list←({TC.Reg.IsValidPackageID_Complete⊃,/1↓⎕NPARTS ⍵}¨list)/list
      :AndIf 1=≢list
          :If Arg.quiet
          :OrIf 1 ∆YesOrNo'Publish ',({~∨/'/\'∊⍵:⍵ ⋄ ⍵↑⍨-¯1+⌊/(⌽⍵)⍳'/\'}1⊃list),' ?'
              zipFilename←⊃list
          :Else
              :Return
          :EndIf
      :EndIf
      'Could not find the ZIP file'Assert TC.F.IsFile zipFilename
      ('"',zipFilename,'" is not a ZIP file')Assert'.zip'≡⎕C ¯4↑zipFilename
      url_←TC.ReplaceRegistryAlias url
      ('"',url,'" is not a Registry')Assert 0<≢url_
      :Trap 98
          TC.PublishPackage zipFilename url_
          r←'Package published on ',url_
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
                  qdmx.EM ⎕SIGNAL qdmx.EN
              :EndSelect
          :Else
              :If 0<≢r←qdmx.EM
                  qdmx.EM ⎕SIGNAL qdmx.EN
              :EndIf
          :EndIf
      :EndTrap
    ∇

    ∇ r←UninstallPackage(path packageID)
    ⍝
      ∘∘∘ ⍝TODO⍝
    ∇

    ∇ r←ListRegistries Arg;type;rawFlag
      type←rawFlag←0
      :If 0≢Arg.Switch'raw'
          rawFlag←Arg.Switch'raw'
      :EndIf
      :If 0≢Arg.Switch'all'
          type←Arg.Switch'all'
      :EndIf
      r←rawFlag TC.ListRegistries type
    ∇

    ∇ r←ListTags Arg;parms
      parms←⎕NS''
      parms.tags←''
      :If 0≢Arg.tags
      :AndIf 0<≢Arg.tags
          parms.tags←Arg.tags
      :EndIf
      r←⍪parms TC.ListTags Arg._1
    ∇

    ∇ r←ListVersions Arg;qdmx
      ⎕SIGNAL 0
      :Trap 98
          r←⍪TC.ListVersions Arg._1
      :Else
          qdmx←⎕DMX
          :If 0=≢qdmx.EM
              r←'Not found: ',Arg._1
          :Else
              r←qdmx.EM
          :EndIf
      :EndTrap
    ∇

    ∇ r←LoadPackage Arg;targetSpace;identifier;saveIn
      (identifier targetSpace)←Arg.(_1 _2)
      '"targetSpace" must specify a fully qualified sub-namespace in # or ⎕SE'Assert'.'∊targetSpace
      '"targetSpace" must specify a fully qualified sub-namespace in # or ⎕SE'Assert~(⊂⎕C targetSpace)∊'#' '⎕se'
      '"targetSpace" is not a valid APL name'Assert ¯1≠⎕NC targetSpace
      saveIn←⍎{⍵↑⍨¯1+⍵⍳'.'}targetSpace
      :If 0=saveIn.⎕NC'targetSpace'
          '"targetSpace" does not specify a fully qualified namespace in either # or ⎕SE'Assert'.'∊targetSpace
          ((1+≢saveIn)↓targetSpace)saveIn.⎕NS''
      :EndIf
      r←⍪TC.LoadPackage identifier targetSpace
    ∇

    ∇ r←PackageConfig Arg;path;ns;newFlag;origData;success;newData;msg;qdmx;filename;what;uri
      r←⍬
      what←Arg._1
      :If ∧/'[]'∊what
          what←TC.ReplaceRegistryAlias what
      :EndIf
      :If TC.Reg.IsHTTP what
          r←TC.ReadPackageConfigFile_ what
      :Else
          path←Arg._1
          filename←path,'/',TC.CFG_NAME
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
                      :Return  ⍝ Give up
                  :EndIf
              :EndIf
              :If TC.F.IsFile filename
                  ns←TC.ReadPackageConfigFile path
                  newFlag←0
              :Else
                  ns←TC.InitPackageConfig ⍬
                  ns.source←TC.MyUserSettings.source
                  newFlag←1
              :EndIf
              :If Arg.edit∨newFlag
                  origData←TC.Reg.JSON ns
                  (success newData)←(CheckPackageConfigFile EditJson)'PackageConfigFile'origData
                  :If success
                      :If 0<≢∊newData
                      :AndIf newFlag∨newData≢origData
                          ns←⎕JSON⍠('Dialect' 'JSON5')⊣newData
                          ns.tags←⎕C ns.tags
                          :Trap 98
                              ns TC.WritePackageConfigFile path
                          :Else
                              qdmx←⎕DMX
                              ⎕←qdmx.EM
                          :EndTrap
                      :EndIf
                  :EndIf
              :Else
                  r←⍪⎕JSON⍠('Dialect' 'JSON5')('Compact' 0)⊣ns
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
      (identifier installFolder)←Arg.(_1 _2)
      :If ~TC.F.IsDir installFolder
          :If 0=Arg.quiet
          :AndIf 1 ∆YesOrNo'The install folder does not yet exist; create?'
              'Create!'TC.F.CheckPath installFolder
          :EndIf
      :EndIf
      r←⍪TC.InstallPackage identifier installFolder
    ∇

    ∇ r←UserSettings dummy;origData;filename
      r←''
      filename←TC.F.NormalizePath TC.MyUserSettings.path2config
      ('User setting file "',filename,'" does not exist?!')Assert ⎕NEXISTS filename
      origData←1⊃⎕NGET filename
      origData←'api_key["]*: "[^"]+'⎕R'api_key: "***'⊣origData          ⍝ Replace the API key by Aserisks
      r←⍪(⊂'User settings in <',filename,'> :'),(⎕UCS 10)(≠⊆⊢)origData
    ∇

    ∇ (success newData)←(CheckFns EditJson)(name origData);temp;msg;flag;json
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
              :ElseIf 0<≢msg←CheckFns json
                  flag←~1 ∆YesOrNo msg,'; want to try fixing the problem (n=abandon changes) ?'
              :Else
                  flag←1
                  newData←json
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
      :Select ⎕C Cmd
      :Case ⎕C'LoadTatin'
          r,←⊂''
          r,←⊂'This loads the Tatin client into ⎕SE and initializes it if it''s not already there.'
          r,←⊂'Allows accessing the Tatin API via ⎕SE.Tatin.'
          r,←⊂''
          r,←⊂'By default the user config file is expected in the user''s home folder, and it will be'
          r,←⊂'created there if it does not already exists.'
          r,←⊂'Instead you may specify a different folder. Note that this is NOT a permanent change;'
          r,←⊂'if you want the change to be permanent specify it via the ]TATIN.UserSettings command'
          r,←⊂'with a -permanent flag.'
          r,←⊂''
          r,←⊂'The -force flag allows you to enforce the load even if ⎕SE.Tatin already exists.'
      :Case ⎕C'ListRegistries'
          r,←⊂''
          r,←⊂'Lists the paths and alias of all Registries defined in the user settings.'
          r,←⊂'* By default the output is beautified. Specify -raw if you want just a raw table.'
          r,←⊂'* By default only "alias" and "uri" are listed; specify -all for all data.'
      :Case ⎕C'ListPackages'
          r,←⊂''
          r,←⊂'Lists all groups defined in the Registry specified as an argument. If no Registry was'
          r,←⊂'specified then a list witg all Registries is presented to the user.'
          r,←⊂'* If you specify an alias it MUST be embraced by square brackets as in [MyAlias]'
          r,←⊂'* Aliases are case insensitive, paths only under Windows.'
          r,←⊂'* It does not matter whether you specify / or \ in a path, or whether it has or has'
          r,←⊂'  not a trailing separator: Tatin is taking care of that.'
          r,←⊂'* By default all packages are listed. You can restrict the output in two ways:'
          r,←⊂'  * -group={groupname} will restrict the list the packages with the given group name.'
          r,←⊂'  * -tags=zip will restrict the output to packages that carry the given tags.'
          r,←⊂'    If you need to specify multiple tags then separate them by commas.'
          r,←⊂'* By default the output is aggregated. Specify -noaggr if you want the full list.'
          r,←⊂'* By default the output is beautified. Specify -raw if you want just a raw list.'
      :Case ⎕C'LoadPackage'
          r,←⊂''
          r,←⊂'Load the specified package and all its dependencies into the workspace'
          r,←⊂'Requires two arguments:'
          r,←⊂''
          r,←⊂'A) First argument'
          r,←(3⍴' ')∘,¨HelpOnPackageID ⍬
          r,←⊂''
          r,←⊂'B) Second argument'
          r,←⊂'   Must be the name of a namespace the package will be loaded into (target space).'
          r,←⊂''
          r,←'#.MyPkgs'ExamplesForLoadAndInstall'LoadPackage'
          r,←⊂''
          r,←⊂'Returns fully qualified name of the package established in the target space'
      :Case ⎕C'InstallPackage'
          r,←⊂''
          r,←⊂'Installs the given package and all its dependencies into the given folder which'
          r,←⊂'must exist.'
          r,←⊂''
          r,←⊂'A) First argument'
          r,←(3⍴' ')∘,¨HelpOnPackageID ⍬
          r,←⊂''
          r,←⊂'B) Second argument'
          r,←⊂'   The second argument must be the path to a folder into which the packages are'
          r,←⊂'   going to be be installed'
          r,←⊂''
          r,←'#.MyPkgs'ExamplesForLoadAndInstall'InstallPackage'
          r,←⊂''
          r,←⊂'Note that the -quiet flag prevents the "Are you sure?" question that is asked in'
          r,←⊂'case the install folder does not exist yet is probably only useful with test cases.'
      :Case ⎕C'LoadDependencies'
          r,←⊂''
          r,←⊂'Takes two arguments:'
          r,←⊂'[1] A folder into which one or more packages have been installed.'
          r,←⊂'[2] A namespace into which the packages are going to be loaded.'
      :Case ⎕C'UserSettings'
          r,←⊂''
          r,←⊂'Prints the user settings to the session in JSON format.'
          r,←⊂''
          r,←⊂'Note that the user command does not give you the means to change the user settings,'
          r,←⊂'or to move it elsewhere. If you want to do anything more than just printing the settings'
          r,←⊂'to the session then you are advised to used the API. Note that there is a dedicated'
          r,←⊂'document for how to use the API, and what for.'
      :Case ⎕C'PackageConfig'
          r,←⊂''
          r,←⊂'The argument may be an HTTP request or a path.'
          r,←⊂'* In case of an HTTP request the package config file is returned as JSON.'
          r,←⊂'  Specifying any of the options has no effect.'
          r,←⊂'* In case of a path the contents of the file "',TC.CFG_NAME,'" is returned.'
          r,←⊂'  In case the file does not exist yet it is created.'
          r,←⊂'  You may edit the file by specifying the -edit flag.'
          r,←⊂'  In case you want to delete the file: specify the -delete flag.'
          r,←⊂''
          r,←⊂'In case of success a text vector with NLs in it is returned, otherwise an empty vector.'
      :Case ⎕C'UninstallPackage'
          r,←⊂'Requires two arguments:'
          r,←⊂'* Path to a folder with installed packages'
          r,←⊂'* Name of the package to be un-installed. If {group} and {name} can identify the'
          r,←⊂'  package uniquely then there is no need for {version}'
          r,←⊂'This command uninstalles the given package and all its dependencies but only if those'
          r,←⊂'are not required by any other packages.'
      :Case ⎕C'PackageDependencies'
          r,←⊂''
          r,←⊂'Takes a path to a folder and returns the contents of the file "apl-dependencies.txt".'
          r,←⊂'You may edit the file by specifying the -edit flag. In case the file does not already'
          r,←⊂'exist it is created.'
          r,←⊂''
          r,←⊂'After the edit the changes are checked for being complete and syntactically correct'
          r,←⊂'JSON, and if they are then they are saved to the given folder.'
          r,←⊂''
          r,←⊂'In case you want to delete the file specify the -delete flag.'
          r,←⊂''
          r,←⊂'Note that the -quiet flag prevents the "Are you sure?" question that is usually asked'
          r,←⊂'in conjunction with the -delete flag; this is probably only useful with test cases.'
      :Case ⎕C'Pack'
          r,←⊂''
          r,←⊂'Creates a ZIP file from the directory ⍵[1] that is a package, and saves it in ⍵[2].'
          r,←⊂''
          r,←⊂'Requires ⍵[1] to have a file "',TC.CFG_NAME,'" defining the package.'
          r,←⊂''
          r,←⊂'Note that if ⍵[2] does not start with "." or "/" it is relative to ⍵[1], Therefore, if you'
          r,←⊂'want to ZIP the package into a sub folder Dist/ inside ⍵[1] you just need to specify Dist/'
      :Case ⎕C'Publish'
          r,←⊂''
          r,←⊂'Publish a package to a particular Registry Server.'
          r,←⊂'Such a package can be one of:'
          r,←⊂'* ZIP file, typically created by calling ]TATIN.Pack'
          r,←⊂'* Folder that contains everything that defines a package; in this case the required ZIP is'
          r,←⊂'  created by "Publish"'
          r,←⊂''
          r,←⊂'Requires two arguments:'
          r,←⊂'* Path to ZIP file or package folder'
          r,←⊂'* URL or alias of a Registry Server'
          r,←⊂''
          r,←⊂'The name of the resulting package is extracted from the ZIP file which therefore must conform'
          r,←⊂'to the Tatin rules.'
          r,←⊂''
          r,←⊂'The -quiet flag suppresses the "Are you sure?" question (test cases).'
      :Case ⎕C'ListVersions'
          r,←⊂''
          r,←⊂'List all versions of the given package. You must specify the package as in'
          r,←⊂'[registry]{group}-{package}'
      :Case ⎕C'Version'
          r,←⊂''
          r,←⊂'Prints name, version number and version date of the client to the session.'
      :Case ⎕C'ListTags'
          r,←⊂''
          r,←⊂'List all unique tags used in all packages, sorted alphabetically.'
      :Else
          r←'Unknown command: ',Cmd
      :EndSelect
    ∇

    ∇ r←HelpOnPackageID dummy
      r←''
      r,←⊂'* A full package ID has three ingredients: {group}-{name}-{major.minor.patch}.'
      r,←⊂'  If a full package ID is specified ALL Registries are scanned; the first one wins.'
      r,←⊂'* Alternatively one can specify a full path or an alias in front of the package ID.'
      r,←⊂'* You may also specify an incomplete package ID (in terms of no patch number, or'
      r,←⊂'  neither minor nor patch number), but then you MUST specify a Registry (path or alias).'
    ∇

    ∇ r←append ExamplesForLoadAndInstall fns
      r←''
      r,←⊂'Valid examples are:'
      r,←⊂'  ]TATIN.',fns,' aplteam-APLTreeUtils-2.0.0 ',append
      r,←⊂'  ]TATIN.',fns,' [tatin]/aplteam-APLTreeUtils2-1.0.0 ',append
      r,←⊂'  ]TATIN.',fns,' [tatin]aplteam-APLTreeUtils2-1.0.0 ',append
      r,←⊂'  ]TATIN.',fns,' [tatin]aplteam-APLTreeUtils2-1.0 ',append
      r,←⊂'  ]TATIN.',fns,' [tatin]aplteam-APLTreeUtils2-1 ',append
      r,←⊂'  ]TATIN.',fns,' [tatin]aplteam-APLTreeUtils2 ',append
      r,←⊂'  ]TATIN.',fns,' /path/to/MyRegistry/aplteam-APLTreeUtils2-1.0.0/ ',append
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
          'Left argument must be a scalar'⎕SIGNAL 11/⍨1≠⍴,default
      :AndIf ~default∊0 1
          'The left argument. if specified, must be a Boolean or empty'⎕SIGNAL 11
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

    ∇ r←CheckPackageConfigFile json;cfg2;ns;extensions
    ⍝ Returns an empty vector if everything is okay and an error message otherwise
      r←''
      ns←⎕JSON⍠('Dialect' 'JSON5')⊣json
      :Trap 98
          cfg2←TC.InitPackageConfig ns
          'name'TC.ValidateName ns.name
          'group'TC.ValidateName ns.group
          {}'api'TC.ValidateName⍣(0<≢ns.api)⊣ns.api
          TC.ValidateVersion ns.version
          ns←TC.ValidateTags ns
          {}{{'source'TC.ValidateName ⍵}⍣(0<≢⍵)⊣⍵}ns.source~'/\'
          :If '.'∊ns.source
              '"source" carries an invalid extension'Assert(⊂3⊃⎕NPARTS ns.source)∊SupportedExtensions
          :EndIf
      :Else
          r←⎕DMX.EM
      :EndTrap
    ∇

    Assert←{⍺←'' ⋄ (,1)≡,⍵:r←1 ⋄ ⎕ML←3 ⋄ ⍺ ⎕SIGNAL 1↓(↑∊⍵),11}
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
      'Invalid right argument; must be a vector of text vectors.'⎕SIGNAL 11/⍨2≠≡options
      'Right argument has more than 999 items'⎕SIGNAL 11/⍨999<≢options
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
      r←1 TC.ListRegistries type
      r[;2]←{0=≢⍵:'' ⋄ '[',⍵,']'}¨r[;2]
    ∇

    ∇ registry←SelectRegistry type;row;list
      :If 1=≢list←GetListOfRegistriesForSelection type
          registry←1⊃list[1;]
      :Else
          :If ⍬≡row←'Select Tatin Registry'Select↓⎕FMT⌽list
              registry←⍬
          :Else
              registry←1⊃list[row;]
          :EndIf
      :EndIf
    ∇

:EndNamespace
