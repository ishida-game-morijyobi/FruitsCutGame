-----------------------------------------------------------------------------------------
--
-- menu.lua
--
-----------------------------------------------------------------------------------------

local composer = require( "composer" )
local scene = composer.newScene()

-- include Corona's "widget" library
local widget = require "widget"

--------------------------------------------

-- forward declarations and other locals
--音楽
title_bgm = media.playSound("bgm/wav/title.wav")
 media.stopSound()
 result_bgm = media.playSound("bgm/wav/result.wav")
 media.stopSound()
main_bgm = media.playSound("bgm/wav/main.wav")

--サウンド
local se_decide = media.newEventSound("se/start.wav")
local se_start = media.newEventSound("se/decide.wav")
local se_finish = media.newEventSound("se/finish.wav")
local se_cut = media.newEventSound("se/SE_Cut1.mp3")
local se_cut2 = media.newEventSound("se/SE_Cut2.mp3")

local playBtn
-- 'onRelease' event listener for playBtn
local function onPlayBtnRelease()
	
	-- go to level1.lua scene
  media.playEventSound(se_start)
  --タイトルBGMストップ
  media.stopSound()
	composer.gotoScene( "level1", "fade", 100 )
	
	return true	-- indicates successful touch
end

function scene:create( event )
	local sceneGroup = self.view

	-- Called when the scene's view does not exist.
	-- 
	-- INSERT code here to initialize the scene
	-- e.g. add display objects to 'sceneGroup', add touch listeners, etc.

	-- display a background image
	local background = display.newImageRect( "images/background.jpg", display.contentWidth, display.contentHeight )
	background.anchorX = 0
	background.anchorY = 0
	background.x, background.y = 0, 0
	-- create/position logo/title image on upper-half of the screen
	local titleLogo = display.newImageRect( "images/logo.png", 264, 42 )
	titleLogo.x = display.contentWidth * 0.5
	titleLogo.y = 100
	
	-- create a widget button (which will loads level1.lua on release)
	playBtn = widget.newButton{
    --何もないとき
		label="Play Now",
		labelColor = { default={255}, over={128} },
    --デフォルト
		defaultFile="images/button.png",
    --ボタンの上に来たときover
		overFile="images/button-over.png",
		width=154, height=40,
		onRelease = onPlayBtnRelease	-- event listener function
	}
	playBtn.x = display.contentWidth*0.5
	playBtn.y = display.contentHeight - 125
	
	-- all display objects must be inserted into group
	sceneGroup:insert( background )
	sceneGroup:insert( titleLogo )
	sceneGroup:insert( playBtn )
end

function scene:show( event )
	local sceneGroup = self.view
	local phase = event.phase
	
	if phase == "will" then
		-- Called when the scene is still off screen and is about to move on screen
	elseif phase == "did" then
		-- Called when the scene is now on screen
		-- 
		-- INSERT code here to make the scene come alive
		-- e.g. start timers, begin animation, play audio, etc.
	end	
end

function scene:hide( event )
	local sceneGroup = self.view
	local phase = event.phase
	
	if event.phase == "will" then
		-- Called when the scene is on screen and is about to move off screen
		--
		-- INSERT code here to pause the scene
		-- e.g. stop timers, stop animation, unload sounds, etc.)
	elseif phase == "did" then
		-- Called when the scene is now off screen
	end	
end

function scene:destroy( event )
	local sceneGroup = self.view
	
	-- Called prior to the removal of scene's "view" (sceneGroup)
	-- 
	-- INSERT code here to cleanup the scene
	-- e.g. remove display objects, remove touch listeners, save state, etc.
	
	if playBtn then
		playBtn:removeSelf()	-- widgets must be manually removed
		playBtn = nil
	end
end

---------------------------------------------------------------------------------

-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

-----------------------------------------------------------------------------------------

return scene
