-- fruits.lua
-- 呪文　fruits モジュール  ...はこのファイルのこと
module(..., package.seeall)
--ランダムの種
math.randomseed( os.time() )
-- 物理エンジンを導入
physics = require "physics"
-- 画像フォルダ
IMAGE_DIR = "images/"
-- 効果音フォルダ
SE_DIR = "se/"
-- 効果音を読み込む
local SE_Cut1 = audio.loadSound(SE_DIR.."SE_Cut1.mp3")
local SE_Cut2 = audio.loadSound(SE_DIR.."SE_Cut2.mp3")
local myGroup = display.newGroup()
local point
local score = 0
local comb = 0
--スコアの初期設定をする
function setScore()
  --scoreで与えられた得点と表示させる
  tfScoreDisplay = display.newText(score,
  display.contentWidth -50 , display.contentHeight*0.05,native.systemFont,30)
  tfScoreDisplay.align = "right"
  
  return  tfScoreDisplay
end

-- スコアを加算し表示する
function addScore(point)
  addcomb()
  point = point * comb
   score = score + point
   print(point)
   tfScoreDisplay.text = score
 
 return score
end
function setComb()
  --conbで与えられた数を表示させる
  CombDisplay = display.newText(comb,
  display.contentWidth *0.5 , display.contentHeight*0.05,native.systemFont,30)
  CombDisplay.align = "right"
  combLabel = display.newText("comb:",winWidth*0.35 ,winHeight*0.05 ,nil,20)

  
  return  ConbDisplay
end
function addcomb()
  comb = comb + 1
  CombDisplay.text = comb
  return comb
end

--　果物を消す
local function removeFruit(event)
  
local params = event.source.params
local fruit = params.fruit
   
  -- 移動などのアニメーションを停止する
transition.cancel(fruit.L)
transition.cancel(fruit.R)
-- 自分自身を削除する
display.remove(fruit)
fruit = nil
 
 end
-- 果物をタッチした時の動作
function onFruit(event)
   -- タッチし終えたとき
if("ended" == event.phase) then
    -- タッチしたスプライトを取得する
    local fruit = event.target 
    
    
    -- 斬った残像エフェクトの表示
    -- 右と左のりんごを割れたように回転させる
    transition.to(fruit.L,{time = 300,rotation=-25,alpha=0.8 })
    transition.to(fruit.R,{time = 300,rotation= 25,alpha=0.8 })
    -- 右と左のりんごを左右に飛ばす
    transition.to(fruit.L,{time = 400,alpha=0.0,x=-100,delay=200})
    transition.to(fruit.R,{time = 400,alpha=0.0,x= 100,delay=200})
     effect = display.newImageRect(IMAGE_DIR.."effectCut.png",64,64)
     effect.x = fruit.x
     effect.y = fruit.y
     effect.rotation = math.random(180)-90
     transition.to(effect,{time = 500,alpha=0.0})
     transition.to(effect,{time = 500,xScale=0.1,yScale=0.1})
     if(math.random(1,2) ==1)then
       audio.play(SE_Cut1)
     else
       audio.play(SE_Cut2)
     end
     
     --爆弾の処理
     if fruit ~= nil and fruit.type == 16 then
       score = math.floor(score / 2)
       comb = 0
      tfScoreDisplay.text = score
      CombDisplay.text = comb
      print("爆弾ドドーんがドーン")
    else if fruit ~= nil and fruit.type < 4 then
      --点数を加える
     addScore(40)
   else if fruit ~= nil and fruit.type < 10 then
      --点数を加える
     addScore(20)
   else
     addScore(10)
    end
  end
end
  
     --イベントに反応しないようにする
     fruit:removeEventListener("touch",onFruit)
     --大体の処理が終わったころに消去する今回は2000ms
         tm = timer.performWithDelay(2000,removeFruit)
    tm.params = { fruit = event.target }
  end  
end

--剛体グループの設定　果物はグループ番号2、果物が干渉する剛体は1と4
physicsGroupFruit = {categoryBits = 2,maskBits = 5}
-- 座標(x,y)に果物を生成する関数
function newFruit()
 fruit = display.newGroup()
 --出現位置設定
rn = math.random(1,4)
 if (rn == 1)then
 fruit.x = display.contentWidth*0.1+display.contentWidth*0.05*math.random(0,10)
 fruit.y = display.contentHeight
end
 if (rn == 2)then
 fruit.x = display.contentWidth*0.1+display.contentWidth*0.05*math.random(0,10)
 fruit.y = display.contentHeight*0
end
 if (rn == 3)then
 fruit.x = display.contentWidth
 fruit.y = display.contentHeight*0.1+display.contentHeight*0.05*math.random(0,15)
end
 if (rn == 4)then
 fruit.x = display.contentWidth*0
 fruit.y = display.contentHeight*0.1+display.contentHeight*0.05*math.random(0,15)
end
 
local type = math.random(1,16)
-- 果物の種類
  fruit.type = type
local left = IMAGE_DIR..string.format("fruit%d.png",type*2-1)
local right = IMAGE_DIR..string.format("fruit%d.png",type*2)
fruit.L = display.newImageRect(fruit,left,32,64)
fruit.R = display.newImageRect(fruit,right,32,64)
fruit.L.anchorX,fruit.L.anchorY = 1,0.5
fruit.R.anchorX,fruit.R.anchorY = 0,0.5

fruit.L.x,fruit.L.y = x,y
fruit.R.x,fruit.R.y = x,y

physics.addBody(fruit,{radius=10,filter=physicsGroupFruit})
--physics.addBody(fruit.L,{radius=10,filter=physicsGroupFruit})
  --fruit:applTorque(360)
    if (rn == 1)then
   fruit:setLinearVelocity(math.random(30,50),-1*math.random(450,500))
 end
 if (rn == 2)then
   fruit:setLinearVelocity(math.random(30,100),math.random(50,100))
 end
 if (rn == 3)then
   fruit:setLinearVelocity(-1*math.random(50,150),-1*math.random(250,350))
 end
 if (rn == 4)then
   fruit:setLinearVelocity(math.random(50,150),-1*math.random(250,300))
 end
  --fruit.L:setLinearVelocity(math.random(30,50),-1*math.random(450,500))
--果物をタッチしたら呼び出される
fruit:addEventListener("touch",onFruit)
  --myGroupmyにImageを挿入
  myGroup:insert(fruit)
  --print (myGroup.numChildren)
return fruit
end
function owari()
  tfScoreDisplay.isVisible = false
  combLabel.isVisible = false
  CombDisplay.isVisible = false
  comb = 0
  score = 0
end

-- 1秒ごとに実行される関数　　
function update(event)
  for i=1,myGroup.numChildren do
    local child = myGroup[i]
    if child~=nil and (child.x > display.contentWidth or child.y > display.contentHeight ) then
      -- アニメーションを停止する
      transition.cancel(child.L)
      transition.cancel(child.R)
      -- 自分自身を削除する
      display.remove(child)
      child = nil
    end
  end 
end   
tm = timer.performWithDelay(500,update,0) 