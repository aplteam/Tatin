:Class APLProcess
    ⍝ Start (and eventually dispose of) an APL process

    (⎕IO ⎕ML)←1 1

    ∇ r←Version
      :Access Public Shared
      r←'APLProcess' '2.3.0' '2024-07-06'
    ∇

    :Field Public Args←''
    :Field Public Ws←''
    :Field Public Exe←''
    :Field Public Proc
    :Field Public onExit←''
    :Field Public RunTime←0    ⍝ Boolean or name of runtime executable
    :Field Public IsSsh
    :Field Public RideInit←''
    :Field Public OutFile←''
    :Field Public WorkingDir←''
    :Field Public Detach←0

    :property Id
    :Access public
        ∇ r←Get ipa
          r←{6::'' ⋄ Proc.Id}''
        ∇
    :endproperty

    ∇ make
      :Access public instance
      :Implements constructor
      make_common
    ∇

    ∇ make1 args;rt;cmd;ws;params;ns;invalid;settings
      :Access Public Instance
      :Implements Constructor
      ⍝ args is:
      ⍝  [1]  the workspace to load
      ⍝  [2]  any command line arguments
      ⍝ {[3]} if present, a Boolean indicating whether to use the runtime version, OR a character vector of the executable name to run
      ⍝ {[4]} if present, the RIDE_INIT parameters to use or RIDE port for SERVE mode
      ⍝ {[5]} if present, a log-file prefix for process output
      ⍝ {[6]} if present, the "current directory" when APL is started
      ⍝ {[7]} if present, and set to 1, do not kill spawned process in destructor
      make_common
      args←(eis⍣({9.1≠⎕NC⊂,'⍵'}⊃args)⊢args)
      :Select {⊃⎕NC⊂,'⍵'}⊃args
      :Case 2.1 ⍝ array
          (Ws Args RunTime RideInit OutFile WorkingDir Detach)←7↑args,(⍴args)↓'' '' 0 RideInit OutFile WorkingDir Detach
      :Case 9.1 ⍝ namespace
          :If 0∊⍴invalid←(settings←args.⎕NL ¯2.1 ¯9.1)~(⎕NEW⊃⊃⎕CLASS ⎕THIS).⎕NL ¯2.2
              args{⍎⍵,'←⍺⍎⍵'}¨settings
          :Else ⋄ ('Invalid APLProcess setting(s): ',,⍕invalid)⎕SIGNAL 11
          :EndIf
      :Else ⋄ 'Invalid constructor argument'⎕SIGNAL 11
      :EndSelect
      :If 'New'≢2⊃⎕SI,⊂'' ⍝ do not autostart if using APLProcess.New
          {}Run
      :EndIf
    ∇

    ∇ make_common
      Proc←⎕NS'' ⍝ Do NOT do this in the field definition
      IsSsh←0
      WorkingDir←1⊃1 ⎕NPARTS'' ⍝ default directory
      PATH←SourcePath
    ∇

    ∇ r←New args
      :Access public shared
      :If 0∊⍴args
          r←##.⎕NEW ⎕THIS
      :Else
          r←##.⎕NEW ⎕THIS args
      :EndIf
    ∇

    ∇ (rc msg)←Run
      :Access Public Instance
      msg←''
      :Trap rc←0
          Start(Ws Args RunTime)
      :Else
          (rc msg)←⎕DMX.(EN EM)
      :EndTrap
    ∇

    ∇ Start(ws args rt);psi;pid;cmd;host;port;keyfile;exe;z;output
      (Ws Args)←ws args
     
      :If 0∊⍴RideInit ⍝ Always set RIDE_INIT so that started process does not inherit this process's setting
          args,←' RIDE_INIT=""'
      :ElseIf 3=10|⎕DR RideInit ⍝ port number?
          args,←' RIDE_INIT="SERVE:*:',(⍕RideInit),'" RIDE_SPAWNED=1'
      :Else
          args,←' RIDE_INIT="',RideInit,'" RIDE_SPAWNED=1'
      :EndIf
     
      :If ~0 2 6∊⍨10|⎕DR rt ⍝ if rt is character or nested, it defines what to start
          Exe←(RunTimeName⍣rt)GetCurrentExecutable ⍝ else, deduce it
      :Else
          Exe←rt
          rt←0
      :EndIf
     
      IsSsh←326=⎕DR Exe ⍝ ssh is denoted by nested exe (host port keyfile exe)
     
      :If IsWin>IsSsh
          ⎕USING←UsingSystemDiagnostics
          psi←⎕NEW Diagnostics.ProcessStartInfo,⊂Exe(ws,' ',args)
          psi.WindowStyle←Diagnostics.ProcessWindowStyle.Minimized
          psi.WorkingDirectory←WorkingDir
     
          :If ~0∊⍴OutFile
              psi.UseShellExecute←0        ⍝ this needs to be false to redirect IO (.NET Core defaults to false, .NET Framework defaults to true)
              psi.StandardOutputEncoding←Text.Encoding.UTF8
              psi.RedirectStandardOutput←1 ⍝ redirect standard output
          :Else
              psi.RedirectStandardOutput←0
              psi.UseShellExecute←1
          :EndIf
     
          Proc←Diagnostics.Process.Start psi
     
      :Else ⍝ Unix
          :If ~∨/'LOG_FILE'⍷args            ⍝ By default
              args,←' LOG_FILE=/dev/null '  ⍝    no log file
          :EndIf
     
          cmd←(~0∊⍴WorkingDir)/'cd ',WorkingDir,'; '
          :If IsSsh
              (host port keyfile exe)←Exe
              cmd,←args,' ',exe,' +s -q ',ws
              Proc←SshProc host port keyfile cmd
          :Else
              z←⍕GetCurrentProcessId
              output←(1+×≢OutFile)⊃'/dev/null'OutFile
              cmd,←'{ ',args,' ',Exe,' +s -q ',ws,' -c APLppid=',z,' </dev/null >',output,' 2>&1 & } ; echo $!'
              pid←tonum⊃_SH cmd
              Proc.Id←pid
              Proc.HasExited←HasExited
          :EndIf
          Proc.StartTime←⎕NEW Time ⎕TS
      :EndIf
    ∇

    ∇ Close;out
      :Implements Destructor
      :If ~Detach
          :If IsWin
          :AndIf ~0∊⍴OutFile
              WaitForKill 200 0.1 ⍝ don't run this in a separate thread if redirecting output on Windows
              :Trap 0
                  out←Proc.StandardOutput.ReadToEnd
                  (⊂out)⎕NPUT OutFile 1
              :EndTrap
          :Else
              WaitForKill&200 0.1 ⍝ otherwise run in a thread for improved throughput
          :EndIf
      :EndIf
    ∇

    ∇ WaitForKill(limit interval);count
      :If (0≠⍴onExit)∧~HasExited ⍝ If the process is still alive
          :Trap 0 ⋄ ⍎onExit ⋄ :EndTrap ⍝ Try this
     
          count←0
          :While ~HasExited
              {}⎕DL interval
              count←count+1
          :Until count>limit
      :EndIf ⍝ OK, have it your own way
     
      {}Kill Proc
    ∇

    ∇ r←GetCurrentProcessId;t
      :Access Public Shared
      :If IsWin
          r←⍎'t'⎕NA'U4 kernel32|GetCurrentProcessId'
      :ElseIf {2::0 ⋄ IsSsh}'' ⍝ instance?
          r←Proc.Pid
      :Else
          r←tonum⊃_SH'echo $PPID'
      :EndIf
    ∇

    ∇ r←GetCurrentExecutable;⎕USING;t;gmfn
      :Access Public Shared
      :If IsWin
          r←''
          :Trap 0
              'gmfn'⎕NA'U4 kernel32|GetModuleFileName* P =T[] U4'
              r←⊃⍴/gmfn 0(1024⍴' ')1024
          :EndTrap
          :If 0∊⍴r
              ⎕USING←UsingSystemDiagnostics
              r←2 ⎕NQ'.' 'GetEnvironment' 'DYALOG'
              r←r,(~(¯1↑r)∊'\/')/'/' ⍝ Add separator if necessary
              r←r,(Diagnostics.Process.GetCurrentProcess.ProcessName),'.exe'
          :EndIf
      :ElseIf {2::0 ⋄ IsSsh}'' ⍝ instance?
          ∘∘∘ ⍝ Not supported
      :Else
          t←⊃1↓_SH'ps -o args -p ',⍕GetCurrentProcessId ⍝ AWS
          :If '"'''∊⍨⊃t  ⍝ if command begins with ' or "
              r←{⍵/⍨{∧\⍵∨≠\⍵}⍵=⊃⍵}t
          :Else
              r←{⍵↑⍨¯1+1⍳⍨(¯1↓0,⍵='\')<⍵=' '}t ⍝ otherwise find first non-escaped space (this will fail on files that end with '\\')
          :EndIf
      :EndIf
    ∇

    ∇ r←RunTimeName exe
    ⍝ Assumes that:
    ⍝ Windows runtime ends in "rt.exe"
    ⍝ *NIX runtime ends in ".rt"
      r←exe
      :If IsWin
          :If 'rt.exe'≢¯6↑{('rt.ex',⍵)[⍵⍳⍨'RT.EX',⍵]}exe ⍝ deal with case insensitivity
              r←'rt.exe',⍨{(~∨\⌽<\⌽'.'=⍵)/⍵}exe
          :EndIf
      :Else
          r←exe,('.rt'≢¯3↑exe)/'.rt'
      :EndIf
    ∇


    ∇ r←KillChildren Exe;kids;⎕USING;p;m;i;mask
      :Access Public Shared
      ⍝ returns [;1] pid [;2] process name of any processes that were not killed
      r←0 2⍴0 ''
      :If ~0∊⍴kids←ListProcesses Exe ⍝ All child processes using the exe
          :If IsWin
              ⎕USING←UsingSystemDiagnostics
              p←Diagnostics.Process.GetProcessById¨kids[;1]
              p.Kill
              ⎕DL 1
              :If 0≠⍴p←(~p.HasExited)/p
                  ⎕DL 1
                  p.Kill
                  ⎕DL 1
                  :If ∨/m←~p.HasExited
                      r←(kids[;1]∊m/p.Id)⌿kids
                  :EndIf
              :EndIf
          :ElseIf {2::0 ⋄ IsSsh}'' ⍝ instance?
              ∘∘∘
          :Else
              mask←(⍬⍴⍴kids)⍴0
              :For i :In ⍳⍴mask
                  mask[i]←Shoot kids[i;1]
              :EndFor
              r←(~mask)⌿kids
          :EndIf
      :EndIf
    ∇

    ∇ r←{all}ListProcesses procName;me;⎕USING;procs;unames;names;name;i;pn;kid;parent;mask;n;cmd;t
      :Access Public Shared
    ⍝ returns either my child processes or all processes
    ⍝ procName is either '' for all children, or the name of a process
    ⍝ r[;1] - child process number (Id)
    ⍝ r[;2] - child process name
      me←GetCurrentProcessId
      r←0 2⍴0 ''
      procName←,procName
      all←{6::⍵ ⋄ all}0 ⍝ default to just my childen
     
      :If IsWin
          ⎕USING←UsingSystemDiagnostics
     
          :If 0∊⍴procName ⋄ procs←Diagnostics.Process.GetProcesses''
          :Else ⋄ procs←Diagnostics.Process.GetProcessesByName⊂procName ⋄ :EndIf
          :If all
              r←↑procs.(Id ProcessName)
              r⌿⍨←r[;1]≠me
          :Else
              :If 0<⍴procs
                  unames←∪names←procs.ProcessName
                  :For name :In unames
                      :For i :In ⍳n←1+.=(,⊂name)⍳names
                          pn←name,(n≠1)/'#',⍕i
                          :Trap 0 ⍝ trap here just in case a process disappeared before we get to it
                              parent←⎕NEW Diagnostics.PerformanceCounter('Process' 'Creating Process Id'pn)
                              :If me=parent.NextValue
                                  kid←⎕NEW Diagnostics.PerformanceCounter('Process' 'Id Process'pn)
                                  r⍪←(kid.NextValue)name
                              :EndIf
                          :EndTrap
                      :EndFor
                  :EndFor
              :EndIf
          :EndIf
      :ElseIf {2::0 ⋄ IsSsh}'' ⍝ instance?
          ∘∘∘
      :Else ⍝ Linux
      ⍝ unfortunately, Ubuntu (and perhaps others) report the PPID of tasks started via ⎕SH as 1
      ⍝ so, the best we can do at this point is identify processes that we tagged with APLppid=
          cmd←'ps -eo pid,args | sed -n ''2,$p''' ⍝ list process id and command line (with arguments)
          cmd,←(~all)/' | grep APLppid=',⍕me      ⍝ is not selecting all, limit to APLProcess's my process started
          cmd,←(t←~0∊⍴procName)/' | grep ',procName ⍝ limit to entries with procName if it exists
          cmd,←' | grep -v grep'                  ⍝ remove "grep" entries
          procs←_SH cmd
          →0⍴⍨0∊⍴procs
          procs←↑(2 part deb)¨procs
          procs[;1]←(⊃tonum)¨procs[;1]
          procs⌿⍨←me≠procs[;1] ⍝ remove my task
          mask←1
          :If t
              mask←∨/¨(procName,' ')∘⍷¨procs[;2],¨' '
          :EndIf
          r←mask⌿procs
      :EndIf
    ∇

    ∇ r←Kill;delay
      :Access Public Instance
      r←0 ⋄ delay←0.1
      :Trap 0
          :If IsWin
              :If IsNetCore ⋄ Proc.Kill ⍬ ⋄ :Else ⋄ Proc.Kill ⋄ :EndIf ⍝ In .Net Core, Kill takes an argument
              :Repeat
                  ⎕DL delay×~Proc.HasExited
                  delay+←delay
              :Until (delay>10)∨Proc.HasExited
          :ElseIf {2::0 ⋄ IsSsh}''
              ∘∘∘
          :Else ⍝ Local UNIX
              {}UNIXIssueKill 3 Proc.Id ⍝ issue strong interrupt
              {}⎕DL 2 ⍝ wait a couple seconds for it to react
              :If ~Proc.HasExited←~UNIXIsRunning Proc.Id
                  {}UNIXIssueKill 9 Proc.Id ⍝ issue strong interrupt
                  {}⎕DL 2 ⍝ wait a couple seconds for it to react
              :AndIf ~Proc.HasExited←~UNIXIsRunning Proc.Id
                  :Repeat
                      ⎕DL delay
                      delay+←delay
                  :Until (delay>10)∨Proc.HasExited←~UNIXIsRunning Proc.Id
              :EndIf
          :EndIf
          r←Proc.HasExited
      :EndTrap
    ∇

    ∇ r←Shoot Proc;MAX;res
      MAX←100
      r←0
      :If 0≠⎕NC⊂'Proc.HasExited'
          :Repeat
              :If ~Proc.HasExited
                  :If IsWin
                      :If IsNetCore ⋄ Proc.Kill ⍬ ⋄ :Else ⋄ Proc.Kill ⋄ :EndIf
                      ⎕DL 0.2
                  :ElseIf {2::0 ⋄ IsSsh}'' ⍝ instance?
                      ∘∘∘
                  :Else
                      {}UNIXIssueKill 3 Proc.Id ⍝ issue strong interrupt AWS
                      {}⎕DL 2 ⍝ wait a couple seconds for it to react
                      Proc.HasExited←~UNIXIsRunning Proc.Id       ⍝ AWS
                  :EndIf
              :EndIf
              MAX-←1
          :Until Proc.HasExited∨MAX≤0
          r←Proc.HasExited
      :ElseIf 2=⎕NC'Proc' ⍝ just a process id?
          {}UNIXIssueKill 9 Proc
          {}⎕DL 2
          r←~UNIXIsRunning Proc
      :EndIf
    ∇

    ∇ r←HasExited
      :Access public instance
      :If IsWin∨{2::0 ⋄ IsSsh}''
          r←{0::⍵ ⋄ Proc.HasExited}1
      :Else
          Proc.HasExited←r←~UNIXIsRunning Proc.Id ⍝ AWS
      :EndIf
    ∇

    ∇ r←GetExitCode
      :Access public Instance
      ⍝ *** EXPERIMENTAL ***
      ⍝ query exit code of process. Attempt to do it in a cross platform way relying on .Net Core. Unfortunetaly
      ⍝ we only use it on Windows atm, so this method can only be used on Windows.
      r←''  ⍝ '' indicates "can't check" (for example, because it is still running) or non-windows platform
      :If HasExited
          :If IsWin
              r←Proc.ExitCode
          :Else
          :EndIf
      :EndIf
    ∇

    ∇ r←IsRunning args;⎕USING;start;exe;pid;proc;diff;res
      :Access public shared
      ⍝ args - pid {exe} {startTS}
      r←0
      args←eis args
      (pid exe start)←3↑args,(⍴args)↓0 ''⍬
      :If IsWin
          ⎕USING←UsingSystemDiagnostics
          :Trap 0
              proc←Diagnostics.Process.GetProcessById pid
              r←~proc.HasExited
          :Else
              :Return
          :EndTrap
          :If ''≢exe
              r∧←exe≡proc.ProcessName
          :EndIf
          :If ⍬≢start
              :Trap 90
                  diff←|-/DateToIDN¨start(proc.StartTime.(Year Month Day Hour Minute Second Millisecond))
                  r∧←diff≤24 60 60 1000⊥0 1 0 0÷×/24 60 60 1000 ⍝ consider it a match within a 1 minute window
              :Else
                  r←0
              :EndTrap
          :EndIf
      :ElseIf {2::0 ⋄ IsSsh}''
          ∘∘∘
      :Else
          r←UNIXIsRunning pid
      :EndIf
    ∇

    ∇ r←Stop pid;proc
      :Access public shared
    ⍝ attempts to stop the process with processID pid
      :If IsWin
          ⎕USING←UsingSystemDiagnostics
          :Trap 0
              proc←Diagnostics.Process.GetProcessById pid
          :Else
              r←1
              :Return
          :EndTrap
          :If IsNetCore ⋄ proc.Kill ⍬ ⋄ :Else ⋄ proc.Kill ⋄ :EndIf
          {}⎕DL 0.5
          r←~IsRunning pid
      :ElseIf {2::0 ⋄ IsSsh}'' ⍝ instance?
          ∘∘∘
      :Else
          r←UnixKill pid
      :EndIf
    ∇

    ∇ r←UNIXIsRunning pid;txt
    ⍝ Return 1 if the process is in the process table and is not a defunct
      :If {2::0 ⋄ IsSsh}'' ⍝ instance?
          ∘∘∘
      :Else
          →(r←' '∨.≠txt←⊃_SH'ps -o comm -p ',(⍕pid),' | sed -n ''2,$p''')↓0
          r←~∨/'<defunct>'⍷txt
      :EndIf
    ∇

    ∇ {r}←UnixKill pid;delay;t
      {}UNIXIssueKill 3 pid ⍝ issue strong interrupt
      {}⎕DL 2 ⍝ wait a couple seconds for it to react
      :If t←UNIXIsRunning pid ⍝ still running?
          {}UNIXIssueKill 9 pid ⍝ bring out the heavy guns
          {}⎕DL 2 ⍝ wait a couple seconds for it to react
      :AndIf t←UNIXIsRunning pid
          delay←0.2
          :Repeat
              ⎕DL delay
              delay+←delay
          :Until (delay>5)∨t←UNIXIsRunning pid ⍝ keep checking (doubling the wait) up to 5 seconds
      :EndIf
      r←~t
    ∇


    ∇ {r}←UNIXIssueKill(signal pid)
      signal pid←⍕¨signal pid
      cmd←'kill -',signal,' ',pid,' >/dev/null 2>&1 ; echo $?'
      :If {2::0 ⋄ IsSsh}'' ⍝ instance?
          ∘∘∘
      :Else
          r←⎕SH cmd
      :EndIf
    ∇

    ∇ r←UNIXGetShortCmd pid
      ⍝ Retrieve short form of cmd used to start process <pid>
      :If {2::0 ⋄ IsSsh}'' ⍝ instance?
          ∘∘∘
      :Else
          :Trap 11
              r←⊃1↓_SH'ps -o comm -p ',⍕pid
          :Else
              r←''
          :EndTrap
      :EndIf
    ∇

    ∇ r←_SH cmd
      :Access public shared
      r←{0::'' ⋄ ⎕SH ⍵}cmd
    ∇

    :Class Time
        :Field Public Year
        :Field Public Month
        :Field Public Day
        :Field Public Hour
        :Field Public Minute
        :Field Public Second
        :Field Public Millisecond

        ∇ make ts
          :Implements Constructor
          :Access Public
          (Year Month Day Hour Minute Second Millisecond)←7↑ts
          ⎕DF(⍕¯2↑'00',⍕Day),'-',((12 3⍴'JanFebMarAprMayJunJulAugSepOctNovDec')[⍬⍴Month;]),'-',(⍕100|Year),' ',1↓⊃,/{':',¯2↑'00',⍕⍵}¨Hour Minute Second
        ∇

    :EndClass

    ∇ r←ProcessUsingPort port;t
    ⍝ return the process ID of the process (if any) using a port
      :Access public shared
      r←⍬
      :If IsWin
          :If ~0∊⍴t←_SH'netstat -a -n -o'
          :AndIf ~0∊⍴t/⍨←∨/¨'LISTENING'∘⍷¨t
          :AndIf ~0∊⍴t/⍨←∨/¨((':',⍕port),' ')∘⍷¨t
              r←∪∊¯1↑¨(//)∘⎕VFI¨t
          :EndIf
      :Else
          :If ~0∊⍴t←_SH'netstat -l -n -p 2>/dev/null | grep '':',(⍕port),' '''
              r←∪∊{⊃(//)⎕VFI{(∧\⍵∊⎕D)/⍵}⊃¯1↑{⎕ML←3 ⋄ (' '≠⍵)⊂⍵}⍵}¨t
          :EndIf
      :EndIf
    ∇

    ∇ r←MyDNSName;GCN
      :Access Public Shared
     
      :If IsWin
          'GCN'⎕NA'I4 Kernel32|GetComputerNameEx* U4 >0T =U4'
          r←2⊃GCN 7 255 255
          :Return
      ⍝ ComputerNameNetBIOS = 0
      ⍝ ComputerNameDnsHostname = 1
      ⍝ ComputerNameDnsDomain = 2
      ⍝ ComputerNameDnsFullyQualified = 3
      ⍝ ComputerNamePhysicalNetBIOS = 4
      ⍝ ComputerNamePhysicalDnsHostname = 5
      ⍝ ComputerNamePhysicalDnsDomain = 6
      ⍝ ComputerNamePhysicalDnsFullyQualified = 7 <<<
      ⍝ ComputerNameMax = 8
      :ElseIf {2::0 ⋄ IsSsh}'' ⍝ instance?
          ∘∘∘ ⍝ Not supported
      :Else
          r←⊃_SH'hostname'
      :EndIf
    ∇

    ∇ idn←DateToIDN ts
      idn←(2 ⎕NQ'.' 'DateToIDN'(3↑ts))+(24 60 60 1000⊥4↑3↓ts)÷86400000
    ∇

    ∇ Proc←SshProc(host user keyfile cmd);conn;z;kf;allpids;guid;listpids;pids;⎕USING;pid;tid
      ⎕USING←'Renci.SshNet,',PATH,'/Renci.SshNet.dll'
      kf←⎕NEW PrivateKeyFile(,⊂keyfile)
      conn←⎕NEW SshClient(host 22 user(,kf))
     
      :Trap 0
          conn.Connect    ⍝ This is defined to be a void()
      :Case 90 ⋄ ('Error creating ssh client instance: ',⎕EXCEPTION.Message)⎕SIGNAL 11
      :Else ⋄ 'Unexpected error creating ssh client instance'⎕SIGNAL 11
      :EndTrap
     
      listpids←{0~⍨2⊃(⎕UCS 10)⎕VFI(conn.RunCommand⊂'ps -u ',user,' | grep dyalog | grep -v grep | awk ''{print $2}''').Result}
      guid←'dyalog-ssh-',(⍕⎕TS)~' '
      pids←listpids ⍬
      Proc←⎕NS''
      Proc.SshConn←conn
      Proc.HasExited←0
      tid←{SshRun conn ⍵ Proc}&⊂cmd
      Proc.tid←tid
      ⎕DL 1
      :If 1=⍴pid←(listpids ⍬)~pids ⋄ pid←⊃pid
      :Else ⋄ ∘∘∘ ⋄ :EndIf ⍝ failed to start
      Proc.Pid←pid
    ∇

    ∇ SshRun(conn cmd proc)
    ⍝ Wait until APL exits, then set HasExited←1
      conn.RunCommand cmd
      proc.HasExited←1
    ∇

    :section Utils

    endswith←{w←,⍵ ⋄ a←,⍺ ⋄ w≡(-(⍴a)⌊⍴w)↑a}
    tonum←{⊃⊃(//)⎕VFI ⍵}
    eis←{2>|≡⍵:,⊂⍵ ⋄ ⍵} ⍝ enclose if simple
    deb←{1↓¯1↓{⍵/⍨~'  '⍷⍵}' ',⍵,' '} ⍝ delete extraneous blanks
    part←{⍵⊆⍨~⍺{⍵∧⍺>+\⍵}' '=⍵} ⍝ partition first ⍺ sections
    nameClass←{⎕NC⊂,'⍵'} ⍝ name class of argument

    ∇ r←IsWin
      :Access public shared
      r←'Win'≡Platform
    ∇

    ∇ r←IsMac
      :Access public shared
      r←'Mac'≡Platform
    ∇

    ∇ r←IsAIX
      :Access public shared
      r←'AIX'≡Platform
    ∇

    ∇ r←Platform
      :Access public shared
      r←3↑⊃#.⎕WG'APLVersion'
    ∇

    ∇ r←IsNetCore
      :Access public shared
      :Trap 11 ⍝ DOMAIN ERROR if 2250⌶ isn't available
          r←1 1≡2↑2250⌶0 ⍝ 2250⌶0 is the preferred mechanism to interrogate .NET availability
      :Else
          r←(,'1')≡2 ⎕NQ'.' 'GetEnvironment' 'DYALOG_NETCORE'
      :EndTrap
    ∇

    ∇ r←UsingSystemDiagnostics
      :Access public shared
      r←(1+IsNetCore)⊃'System,System.dll' 'System,System.Diagnostics.Process'
    ∇

    ∇ path←SourcePath;source
    ⍝ Determine the source path of the class
      :Trap 6
          source←⍎'(⊃⊃⎕CLASS ⎕THIS).SALT_Data.SourceFile' ⍝ ⍎ works around a bug
      :Else
          :If 0=⍴source←{((⊃¨⍵)⍳⊃⊃⎕CLASS ⎕THIS)⊃⍵,⊂''}5177⌶⍬ ⍝ 5177⌶⍬ - list loaded file objects
              source←⎕WSID
          :Else ⋄ source←4⊃source
          :EndIf
      :EndTrap
      path←{(-⌊/(⌽⍵)⍳'\/')↓⍵}source
    ∇

    :endsection

:EndClass
