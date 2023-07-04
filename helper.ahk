



;; lts coding section (in future probably other file)
latest:="(None)" ;;latest combo patch
qend:="(None)"   ;;character to use when ending an LST
comande:=false   ;;indicate running a function
comande_fun_end:=42 ;;indicate function to call afterwartd
comande_arg:=""  ;; indicate string of current argument
comande_fun_name:=42 ;; curret comande name
LTS(name,char){
    ;;function for creating lts hotstring
    new_func(par1){
        global latest,qend
        latest:=name
        qend:=char
        SendText(char)
    }
    return new_func
}
LTSreset(){
    global latest
    latest:="(None)"
}
PLTS(){
    SendText(latest)
}
LTSisdefault(){
    if (latest=="(None)"){
        return True
    }
    else {
        return False
    }
}
LTSis(arg){
    if (latest==arg){
        return True
    }
    return False
}
PLTSisdefault(){
    if (LTSisdefault()){
        SendText("True")
    }
    else{
        SendText("False")
    }
}
LTSdo(char){
    global latest
    latest:="(None)"
    Send("{Bs}")
    SendText(char)
}
LTScont(name,char){
    global latest
    latest:=(latest . "/" . name)
    Send("{Bs}")
    SendText(char)
}
LTSend(){
    global latest,qend
    Send("{Bs}")
    SendText(qend)
    Send("{Space}")
    latest:="(None)"
    qend:="(None)"
}
Hotstring "::ℵdebug:ltsdebug", PLTS
Hotstring "::ℵdebug:ltsisdef", PLTSisdefault

;; end of lts


;; start of cmd

command(name,procesor){    
    cmd_prc(arg){
        ih := InputHook("V",' ')
        ih.Start()
        ih.Wait()
        size:=StrLen(comande_fun_name . ih.Input . "⌘ ")
        while (size!=0){
            size:=size-1
            Send("{Bs}")
        }
        procesor(ih.Input)

    }
    return cmd_prc
}





state_restart(){
    comande:=False
    comande_arg:=""
    comande_fun_end:=false
    LTSreset()
}
<^>!+BackSpace::LTSreset()

;; variants selection
var_isactive:=false
var_set:=false
var_e_s:=-1
var_selectetnumber:=-1
var_type:=false

variant(set,starter_point){
    
    var_prc(*){
        global var_isactive,var_set,var_selectetnumber,var_type
        var_type:=1
        var_isactive:=true
        var_set:=set
        var_selectetnumber:=starter_point
        SendText("v/" . var_set[var_selectetnumber])
        return
    }
    return var_prc
}
variant_n(starter_point,start,size){
    
    var_prc(*){
        global var_isactive,var_set,var_selectetnumber,var_type,var_e_s
        var_type:=2
        var_isactive:=true
        var_set:=start
        var_selectetnumber:=starter_point
        var_e_s:=size
        SendText("v/" . Chr(var_set+var_selectetnumber))
        return
    }
    return var_prc
}
var_right(*){
    global var_isactive
    if (var_isactive){
    global var_selectetnumber,var_set,var_type,var_e_s
    if (var_type==1){
        if (not (var_selectetnumber+1>var_set.Length)){
            var_selectetnumber++
            Send("{Bs}")
            SendText(var_set[var_selectetnumber])
        }
    }else{
        if (not (var_selectetnumber+1>var_e_s)){
            var_selectetnumber++
            Send("{Bs}")
            SendText(Chr(var_set+var_selectetnumber))
        }
    }
    return
    }
}
var_left(*){
    global var_isactive
    if (var_isactive){
    global var_selectetnumber,var_set,var_type,var_e_s
    if (var_type==1){
        if (not (var_selectetnumber-1<1)){
            var_selectetnumber--
            Send("{Bs}")
            SendText(var_set[var_selectetnumber])
        }
    }else{
        if (not (var_selectetnumber-1<0)){
            var_selectetnumber--
            Send("{Bs}")
            SendText(Chr(var_set+var_selectetnumber))
        }
    }
    return
    }
}
var_isactivate(){
    return var_isactive
}
var_end(){

    global var_isactive,var_set,var_selectetnumber,var_type
    var_isactive:=false
    Send("{Bs}{Bs}{Bs}")
    if (var_type==1){
        SendText(var_set[var_selectetnumber])
    }else{
        SendText(Chr(var_set+var_selectetnumber))
    }
    
    var_selectetnumber:=-1
    var_set:=false
    var_e_s:=-1
    var_type:=false
    return
}
   
#hotif var_isactivate()
Up::var_right()
Down::var_left()
Left::var_left()
Right::var_right()
Space::var_end() 
#hotif
;; General
ChangeWindow(win,fallback:=false){
    w(*){
        Try{
            WinActivate("ahk_exe " . win)
        } 
        Catch {
            if (fallback!=false){
                Run(fallback)
            }
        }
    }
    return w
}
RunLink(link){
    w(*){
        Run(Link)
    }
    return w
}



Hotstring ":c:ℵdebug:v/Alfa", variant_n(65,0,128)
Hotstring ":c:ℵdebug:v/alfa", variant_n(97,0,128)
Hotstring ":c:ℵdebug:v/Omega", variant_n(87,0,128)
Hotstring ":c:ℵdebug:v/omega", variant_n(119,0,128)
