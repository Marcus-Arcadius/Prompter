
 
;     888                                                               888  888   888888888   .d8888b.   .d8888b.   d888   
;     888                                                               888  888   888        d88P  Y88b d88P  Y88b d8888   
;     888                                                             888888888888 888        888        888    888   888   
; .d88888  8888b.  88888b.   .d88b.   .d88b.  88888b.   .d88b.  888d888 888  888   8888888b.  888d888b.  888    888   888   
;d88" 888     "88b 888 "88b d88""88b d88""88b 888 "88b d8P  Y8b 888P"   888  888        "Y88b 888P "Y88b 888    888   888   
;888  888 .d888888 888  888 888  888 888  888 888  888 88888888 888   888888888888        888 888    888 888    888   888   
;Y88b 888 888  888 888 d88P Y88..88P Y88..88P 888 d88P Y8b.     888     888  888   Y88b  d88P Y88b  d88P Y88b  d88P   888   
; "Y88888 "Y888888 88888P"   "Y88P"   "Y88P"  88888P"   "Y8888  888     888  888    "Y8888P"   "Y8888P"   "Y8888P"  8888888 
;                  888                        888                                                                           
;                  888                        888                                                                           
;                  888                        888                                                                           

 
#NoEnv  
SendMode Input  
SetWorkingDir %A_ScriptDir% 
#SingleInstance,Force
;Menu, Tray, Icon, %A_ScriptDir%\Tray.png

CusResCounter := 0

Gui, Font, s13
SetBatchLines -1
SetTimer, Smit, 10
Gui Add, Edit, x6 y3 w638 h58 vPrompt
Gui Add, Slider, x0 y85 w100 h29 Range-20-20 Tickinterval5 vSli1, 7
Gui Add, Slider, x100 y85 w101 h29 Range1-50 Tickinterval5 vSli2, 50
Gui Add, Slider, x200 y85 w100 h29 Range1-4 Tickinterval1 vSli3, 4
Gui Add, Edit, x305 y93 w105 h28 hwndEdit2 vSeed,
EM_SETCUEBANNER(Edit2, "SEED")
Gui Add, Text, x10 y64 w188 h23 vCfg, CFG_S: 7
Gui Add, Text, x107 y64 w168 h23 vSTEPS, STEPS: 50
Gui Add, Text, x207 y64 w90 h23 vNum, IMAGES: 4
Gui Add, DropDownList, x305 y64 w105 vSamp, MODEL||k_euler|k_euler_ancestral|k_heun|k_dpm_2|k_dpm_2_ancestral|ddim|plms|
Gui Add, DropDownList, x474 y93 w68 vShortAspect gStarter, 1:1||32:9|21:9|16:9|9:16|16:10|2:3|4:3|4:5|1:2|2:1|
Gui Add, Edit, x412 y93 w60 h28 hwndEdit3 vCustomRes gCusRes
EM_SETCUEBANNER(Edit3, "RES")
Gui, Add, DropDownList, x544 y93 w100 vAspectRatiosFull, 512x512||64x64|128x128|192x192|256x256|320x320|384x384|448x448|512x512|576x576|640x640|704x704|768x768|832x832|896x896|960x960|1024x1024
Gui Add, Button, x411 y63 w78 h30 vSendP gSend, SEND
Gui Add, Button, x567 y63 w78 h30 vResetP gReset, RESET
Gui Add, Button, x489 y63 w78 h30 vCopy gCopy, COPY
Gui Show, w650 h127, Prompter

return

Smit:
{
	Gui, Submit, Nohide
	GuiControl,, Cfg, CFG_S: %Sli1%
	GuiControl,, Steps, STEPS: %Sli2%
	GuiControl,, Num, IMAGES: %Sli3%
	return
}

Send:
{
	Gosub, Copy
	IfWinExist, ahk_exe Discord.exe
	{
		WinGetTitle, titleDis, ahk_exe Discord.exe
		if InStr(titleDis, "dream")
		{
			WinActivate, ahk_exe Discord.exe
			IfWinActive, ahk_exe Discord.exe
			{
				Send {Escape}
				Sleep, 400
				Send, ^v
				Send, {Enter}
			}
		}
		else
		{
			MsgBox,,ERROR, Not in Dream channel (1-50)
		}
	}
	else
	{
		MsgBox,,ERROR, Discord not open
	}
	return
}

Reset:
{
	GuiControl,, Sli1, 7
	GuiControl,, Sli2, 50
	GuiControl,, Sli3, 4
	GuiControl,, Seed, 
	GuiControl,, CustomRes,
	GuiControl,, ShortAspect, |1:1||32:9|21:9|16:9|9:16|16:10|2:3|4:3|4:5|1:2|2:1|
	GuiControl,, AspectRatiosFull, |512x512||64x64|128x128|192x192|256x256|320x320|384x384|448x448|512x512|576x576|640x640|704x704|768x768|832x832|896x896|960x960|1024x1024
	GuiControl,, Samp, |MODEL||k_euler|k_euler_ancestral|k_heun|k_dpm_2|k_dpm_2_ancestral|ddim|plms|
	GuiControl,, Prompt, 
	return	
}

CusRes:
{
	CusResCounter := 1	
	Gosub, Starter
	return
}

Starter:
{
	64NumInc := 64
	BigSmallNumCounter := 0
	ListDisplayCounter := 0
	ListRes := 
	RatioDiv := 
	RoundNum2 :=
	Small :=
	Big :=
	Gui, Submit,Nohide
	if CusResCounter = 1
	{
		CusResCounter := 0
		SplitNumArray := StrSplit(CustomRes,":")
		if SplitNumArray[1] > 0 and SplitNumArray[2] > 0
		{
			GuiControl,, ShortAspect,←||
			if SplitNumArray[1] > SplitNumArray[2]
			{
				Big := SplitNumArray[1] 
				Small := SplitNumArray[2]
				BigSmallNumCounter := 1
				Gosub, ARUnder1MP
			}
			else
			{
				Big := SplitNumArray[1] 
				Small := SplitNumArray[2]
				BigSmallNumCounter := 0
				Gosub, ARUnder1MP
			}
		}
		else
		{
			return
		}
		
	}
	else
	{
		SplitNumArray := StrSplit(ShortAspect,":")
		if SplitNumArray[1] > SplitNumArray[2]
		{
			Big := SplitNumArray[1] 
			Small := SplitNumArray[2]
			BigSmallNumCounter := 1
			Gosub, ARUnder1MP
		}
		else
		{
			Big := SplitNumArray[1] 
			Small := SplitNumArray[2]
			BigSmallNumCounter := 0
			Gosub, ARUnder1MP
		}
	}
	return
}
	
ARUnder1MP:
{
	
	Loop,
	{
		if 64NumInc+RatioDiv > 2048
		{
			GuiControl,, AspectRatiosFull,|%ListRes%
			Break
		}
		if BigSmallNumCounter = 1
		{
			RatioDiv := 64NumInc/(Big/Small) 
		}
		else
		{
			RatioDiv := 64NumInc*(Small/Big) 
		}
		RoundNum2 := Ceil(RatioDiv)
		if ListDisplayCounter = 0
		{
			ListRes := ListRes . 64NumInc "x" RoundNum2 "||"
			ListDisplayCounter := 1
		}
		else
		{
			ListRes := ListRes . 64NumInc "x" RoundNum2 "|"
		}
		64NumInc += 64
	}
	return
}

Copy:
{
	IfWinActive, Prompter
	{
		if Prompt = 
		{
			
		}
		else
		{
			FinalPrompt = -C %Sli1% -s %Sli2% -n %Sli3%
			if Seed = 
			{
				
			}
			else
			{
				FinalPrompt = %FinalPrompt% -S %Seed%
			}
			if Samp = MODEL
			{
				
			}
			else
			{
				FinalPrompt = %FinalPrompt% -A %Samp%
			}
			SplitFinal := StrSplit(AspectRatiosFull,"x")
			FinalPrompt := FinalPrompt " -W " SplitFinal[1] " -H " SplitFinal[2]
			clipboard := "!dream" " " """" Prompt """" " " FinalPrompt
		}
	}
	return
}

EM_SETCUEBANNER(hWnd, Cue)
{
	return DllCall("user32.dll\SendMessage", "Ptr", hWnd, "UInt", 0x1501, "Ptr", 1, "Ptr", &Cue, "Ptr")
}
;dapooper#5601
#IfWinActive, WinTitleOfYourAppHere
Up::return
Down::return
return
GuiClose:
ExitApp
