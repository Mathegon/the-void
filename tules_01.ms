

rollout TuleBox "TuleBox" width:240 height:500
(
	local b = openBitMap(@"https://github.com/Mathegon/the-void/blob/master/toaster.png")
	imgTag imgLogo "logo" tooltip:"logo" style:#bmp_center bitmap:b align:#center height:100 width:208
	
	button 'btn1_rnd_pre' "Render Precheck" pos:[16,280] width:96 height:24 toolTip:"Render a precheck - no need to disable in Render settings" align:#left
	button 'btn2_set_high' "Set High Render" pos:[120,280] width:88 height:24 toolTip:"Prepare for SLA Deadline" align:#left
	button 'btn3_save' "SAVE" pos:[16,336] width:64 height:24 toolTip:"Save and auto disable incremental save" align:#left
	button 'btn4_save_inc' "Save Incremental" pos:[104,336] width:104 height:24 align:#left
	GroupBox 'grp1' "Render" pos:[8,264] width:208 height:48 align:#left
	GroupBox 'grp2' "Save" pos:[8,320] width:208 height:48 align:#left
	GroupBox 'grp8' "Settings" pos:[8,128] width:208 height:128 align:#left
	
	label 'lbl1' "file" pos:[16,160] width:160 height:16 bold:true align:#left
	label 'lbl2' "resolution" pos:[16,200] width:168 height:16 align:#left
	label 'lbl3' "thresh" pos:[16,224] width:160 height:16 align:#left
	
		
		
		
	on TuleBox open do
	(
		vr=renderers.current
		a = vr.twoLevel_threshold
		
		f = maxFileName
		w = renderWidth as string
		h = renderHeight as string
		t = a as string
		
		lbl1.text = "FILE: " + f
		lbl2.text = "Resolution: " + w + " X " + h		
		lbl3.text = "Threshold: " + t
	)
	on btn1_rnd_pre pressed do
	(
		renderWidth = 1000
		renderHeight = 1000
		renderSceneDialog.update()
		
			vr=renderers.current
			vr.output_splitgbuffer = false
			
			a=vr.twoLevel_threshold
		
			w = renderWidth as string
			h = renderHeight as string			
		
			low=0.01
			if a < low then b=a*10 else b=a 
			
			
			vr.twoLevel_threshold = b
			t = b as string
		
		lbl2.text = "Resolution: " + w + " X " + h		
		lbl3.text = "Threshold: " + t
		actionMan.executeAction 0 "50030"
		
		)
	on btn2_set_high pressed do
	(
		renderWidth = 4000	
		renderHeight = 4000				
		renderSceneDialog.update()
		
			vr=renderers.current
			vr.output_splitgbuffer = true
			
			a=vr.twoLevel_threshold
		
			w = renderWidth as string
			h = renderHeight as string
						
			hi=0.01		
			if a >= hi then b=a/10 else b=a 
			
		
			vr.twoLevel_threshold = b
			t = b as string
		
		lbl2.text = "Resolution: " + w + " X " + h		
		lbl3.text = "Threshold: " + t
		
		)
	on btn3_save pressed do
	(
			saveMaxFile maxFileName
			lbl1.text = "FILE: " + maxFileName
		)
	on btn4_save_inc pressed do
	(
			if maxFileName != "" then
			(
					numChar = 3
					NameFile = trimright maxFileName ".max"
					numVar = 0
					numSeq = 0
					seqPos = 0
					seqArray = #()
					seqDigArray = #()
					numVarOld = 0

				for i=1 to NameFile.count do
				(
					NameLetter	= substring NameFile i 1

					case of
					(
						(NameLetter == "0"): numVar = numVar + 1
						(NameLetter == "1"): numVar = numVar + 1
						(NameLetter == "2"): numVar = numVar + 1
						(NameLetter == "3"): numVar = numVar + 1
						(NameLetter == "4"): numVar = numVar + 1
						(NameLetter == "5"): numVar = numVar + 1
						(NameLetter == "6"): numVar = numVar + 1
						(NameLetter == "7"): numVar = numVar + 1
						(NameLetter == "8"): numVar = numVar + 1
						(NameLetter == "9"): numVar = numVar + 1
						default: numVar = 0
					)
					
					if numVar > 0 then
					(
						
						if numSeq == 0 then
						(
							numSeq = 1
							append seqArray i
						)
					)
					else
					(
						numSeq = 0
						if numVarOld > 0 then
						(
							append seqDigArray numVarOld
						)
					)
					
					numVarOld = numVar
				)

				seqPos = seqArray[seqArray.count]
				NameB4 = substring NameFile 1 (seqPos - 1)
				
				if seqDigArray[seqArray.count] == undefined then
				(
					seqDig = (NameFile.count - NameB4.count)
				)
				else
				(
					seqDig = seqDigArray[seqArray.count]
				)

				NameAfter = substring NameFile (seqPos + seqDig) NameFile.count
				NameNum = substring NameFile seqPos seqDig 
				NewNum = free
				NameNumMore = NameNum as number + 1
				NumDec = NameNumMore as string
				NewNum = ""
				
				for i=1 to (seqDig - NumDec.count) do
				(
					NewNum = (append "0" NewNum)
				)
				
				NewNum = (append NewNum NumDec)
				NameFile = NameB4 + NewNum + NameAfter + ".max"
				FullName = maxFilePath + NameFile
				savemaxfile FullName
				
			)
			else
			(
				
				SaveFileName = getSaveFileName  \
				caption:"Save Max File" \
				filename:(getDir #Scene + @"\") \
				types:"3ds max(*.max)|*.max" \
				historyCategory:"RTTObjectPresets"
				
						if SaveFileName != undefined then
						(
							savemaxfile SaveFileName
						)
			)
			lbl1.text = "FILE: " + NameFile
		)
)
rollout Handy "Handy Stuff" width:240 height:120
(
	button 'btn10_cam' "Select camera" pos:[16,10] width:96 height:24 toolTip:"Get the viewport camera to modify" align:#left
	
	on btn10_cam pressed do
	(
			actionMan.executeAction 0 "40247"
		)
	label 'lbl10' "made by Mattias Johansson" pos:[80,60] width:160 height:16 align:#right

	)
	
MainFloater = NewRolloutFloater "" 230 500
addRollout TuleBox MainFloater
addRollout Handy MainFloater
