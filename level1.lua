-----------------------------------------------------------------------------------------
--
-- level1.lua
--
-----------------------------------------------------------------------------------------
local fruits=require("fruits")
local composer = require( "composer" )
local scene = composer.newScene()
-- include Corona's "physics" library
local physics = require "physics"
--重力設定
physics.setGravity(0,8)
--エンジンをスタートさせる
physics.start();
--エンジンを一時停止させる
physics.pause()
--物理エンジンの表示モード
physics.setDrawMode("hybrid")
--------------------------------------------
--端末の幅
winWidth = display.contentWidth
--端末の高さ
winHeight = display.contentHeight
-- 画像フォルダ
IMAGE_DIR = "images/";
CountDownTimer = 12
delaytime = 500
time_limit = CountDownTimer
result_bgm = media.playSound("bgm/wav/result.wav")
tobif = 0

function Ending(event)
   if ("ended" == event.phase) then
     --gameoverTextボタンのタッチイベント感知をとめる
     title_button:removeEventListener("touch",Ending)
     --　タイトルに戻るボタンとリプレイボタンを表示させる
     title_button.isVisible = true
     background.isVisible = true
     grass.isVisible = true
     timerLabel.isVisible = true
     tfScoreDisplay = true
     tobif = 0
     CountDownTimer = time_limit
     fruits.owari()
     composer.gotoScene( "menu" ,"fade",500)
     
     --ゲームBGMを停止
     media.stopSound()
     --　エンディングBGMを再生
     local ending_bgm = media.playSound("bgm/wav/result.wav")
  
  end
 end
function scene:create( event )
--時間
timerLabel = display.newText(CountDownTimer,display.contentWidth*0.1 ,display.contentHeight*0.05 ,nil,28)
timerLabel:setTextColor(255,29,0)
-- forward declarations and other locals
local screenW, screenH, halfW = display.contentWidth, display.contentHeight, display.contentWidth*0.5
title_button = display.newImage( IMAGE_DIR.."title_button.png",winWidth*0.6,winHeight*0.6)
      
      tobif = 0
      CountDownTimer = time_limit
	-- Called when the scene's view does not exist.
	-- 
	-- INSERT code here to initialize the scene
	-- e.g. add display objects to 'sceneGroup', add touch listeners, etc.

	local sceneGroup = self.view
--■背景と芝生を設置する関数■--
function setbackground()
  background = display.newImageRect( "images/bg.png", screenW, screenH )
	background.anchorX = 0
	background.anchorY = 0
  background.x = 0
  background.y = 0
  
	-- create a grass object and add physics (with custom shape)
	grass = display.newImageRect( "images/grass.png", screenW, 82 )
	grass.anchorX = 0
	grass.anchorY = 1
	grass.x, grass.y = 0, display.contentHeight
	
	-- define a shape that's slightly shorter than image bounds (set draw mode to "hybrid" or "debug" to see)
  --ここ注目!! physicsは物理 Body,grassは剛体
	local grassShape = { -halfW,-grass.contentHeight/2, halfW,-grass.contentHeight/2, halfW,grass.contentHeight/2, -halfW,grass.contentHeight/2}
	--physics.addBody( grass, "static", { friction=0.3, shape=grassShape } )
	
end

  setbackground()
  --左右の透明な壁
  function setwall()
  w1 = display.newRect(0, display.contentHeight/2, 5, display.contentHeight)
  w1:setFillColor(255, 0, 0)
  w2 = display.newRect(display.contentWidth, display.contentHeight/2, 5, display.contentHeight)
  w2:setFillColor(255, 0, 0)
  --physics.addBody(w1,"static")
  --physics.addBody(w2,"static")
  return setwall
  end
local wall = setwall()
--score表示の初期設定
fruits.setScore()
fruits.setComb()

  --円を追加
  --local ball = display.newCircle(halfW/2,0,10)
  --ball:setFillColor(math.random(255),math.random(255),math.random(255))
  --円の剛体をボールにくっつける bounce =弾性
  --physics.addBody(ball,{bounce= 0.89,radius=10})
  --ball:applyTorque(360)
  --四角を追加
  --local square = display.newRect(display.contentWidth/2,display.contentHeight - grass.contentHeight,20,50)
  --座標の指定
  --square.anchorX = 0.5
  --square.anchorY = 1
  --色
  --square:setFillColor(math.random(255),math.random(255),math.random(255))
  --剛体追加 密度 摩擦 弾性の設定
  --physics.addBody(square,"dynamic",{density = 10,friction=0.03,bounce = 0.3})
  
  --剛体に直接的なベクトルの速度を与える
  --square:setLinearVelocity(0,-300)
  
  --力を加える方向のx,yと力を与える位置を設定
  --square:applyForce(0.2,0,0,-20)
  
	--瞬間的な衝撃を与える
  --square:applyLinearImpulse(0.009,0,0,-20)
  --斜めの衝撃
  --square:applyAngularImpulse(45)
  
  --回転力を加える
  --square:applyTorque(3600)
  -- all display objects must be inserted into group
  title_button.isVisible = false
      background.isVisible = true
      grass.isVisible = true
      timerLabel.isVisible = true
      tfScoreDisplay = true
	sceneGroup:insert( background )
	sceneGroup:insert( grass)
  --ボール,四角をシーンに追加
  --sceneGroup:insert(ball)
  --sceneGroup:insert(square)--
end


--　残り時間を減らす関数
local function timeCheck()
   if(tobif==0)then
     tm = timer.performWithDelay(500,update,0)
     tobif =1
   end
   CountDownTimer = CountDownTimer-1
  if CountDownTimer>=10 then
    timerLabel.text = CountDownTimer
  elseif (CountDownTimer>0) then
     timerLabel.text = "0" .. CountDownTimer
  elseif (CountDownTimer==0) then
    timerLabel.text = "0" .. CountDownTimer
    title_button.isVisible = true
    media.stopSound()
    result_bgm = media.playSound("bgm/wav/result.wav")
    title_button:addEventListener("touch",Ending)
  end
end
--生成された果物を管理する配列
--local fruitsTable= {}
 
 -- 1秒ごとに実行される関数　　
  function update(event)
   --print(os.clock())
  --local fruit = fruits.newFruit(display.contentWidth*0.5,display.contentHeight*0.5)
 if (CountDownTimer == 3)then
     timer.pause(tm)
     
   end
   
  local fruit = fruits.newFruit(display.contentWidth*math.random(),display.contentHeight*1)
  
--table.insert(fruitsTable,fruit)
--生成された果物の数を表示する#はテーブルの中のオブジェクトの数
--print(#fruitsTable)
  
end
  -- 1.5秒ごとにupdate関数を実行する
 GameTimer1 = timer.performWithDelay(1000,timeCheck,time_limit)

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
		physics.start()
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
		physics.stop()
	elseif phase == "did" then
		-- Called when the scene is now off screen
	end	
	
end

function scene:destroy( event )

	-- Called prior to the removal of scene's "view" (sceneGroup)
	-- 
	-- INSERT code here to cleanup the scene
	-- e.g. remove display objects, remove touch listeners, save state, etc.
	local sceneGroup = self.view
	
	package.loaded[physics] = nil
	physics = nil
end

---------------------------------------------------------------------------------

-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

-----------------------------------------------------------------------------------------

return scene
