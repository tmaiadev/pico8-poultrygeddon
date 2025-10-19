pico-8 cartridge // http://www.pico-8.com
version 43
__lua__
function _init()
	plr=plr_new()
end

function _update60()
	plr_update(plr)
end

function _draw()
	cls()
	
	plr_draw(plr)
end
-->8
-- player

plr_anims={
	idle=1,
	dead=11,
	attacking={3,5},
	running={7,9}
}

function plr_new(x,y)
	local plr={
		x=x or 0,
		y=x or 0,
		w=16,
		h=16,
		spr=1,
		face_left=false,
		is_running=false,
	}
	
	local ani_running=
		plr_mk_ani_running(plr)
	plr.ani_running = ani_running
	
	return plr
end

function plr_update(plr)
	-- if moving --
	if btn(➡️) or
				btn(⬅️) or
				btn(⬆️) or
				btn(⬇️) then
		plr.is_running=true

		-- move x --
		if btn(➡️) then
			plr.x+=1
			plr.face_left=false
		elseif btn(⬅️) then
			plr.x-=1
			plr.face_left=true
		end
		
		-- move y --
		if btn(⬆️) then
			plr.y-=1
		elseif btn(⬇️) then
			plr.y+=1
		end
	else -- not moving --
		plr.is_running=false
	end -- end of moving --

	-- update player sprites --
	if plr.is_running then
		ani_update(plr.ani_running)
	else
		plr.spr=1
	end
end

function plr_draw(plr)
	sspr(
		plr.spr * 8,
		0,
		plr.w,
		plr.h,
		plr.x,
		plr.y,
		plr.w,
		plr.h,
		plr.face_left
	)
end

function plr_mk_ani_running(plr)
	local a=ani_new(8,true)
	local sprs=plr_anims.running
	
	for s in all(sprs) do
		ani_add(a,function()
			plr.spr=s
		end)
	end
	
	ani_start(a)
	return a
end
-->8
-- utils
function ani_new(fps, loop)
	return {
		fps=fps or 60,
		loop=loop or false,
		frame=1,
		frames={},
		started=false,
		paused=false,
		ended=false,
		dlt=0
	}
end

function ani_add(ani,fn,dur)
	dur=dur or 1
	for i=1,dur do
		add(ani.frames,fn)
	end
end

function ani_start(ani)
	ani.started=true
	ani.paused=false
	ani.ended=false
end

function ani_pause(ani)
	ani.paused=true
end

function ani_resume(ani)
	ani.paused=false
end

function ani_update(ani)
	-- kill if animation
	-- is not running
	if not ani.started
				or ani.paused
				or ani.ended then
		return
	end
	
	-- update delta
	ani.dlt+=1
	
	if ani.dlt>60 then
		ani.dlt=1
	end
	
	-- calc frame trigger
	local t=60/ani.fps
	
	-- update current frame
	if ani.dlt%t==0 then
		ani.frame+=1
		
		if ani.frame>#ani.frames then
			if ani.loop then
				ani.frame=1
			else
				ani.ended=true
				ani.frame-=1 -- return to last frame
			end
		end
	end
	
	-- run current frame
	local fn=ani.frames[ani.frame]
	fn()
end
__gfx__
00000000000499099000000000049909900000000004990990000000000499099000000000049909900000000000000000000000000000000000000000000000
000000000004f991199000000004f991199000000004f991199000000004f991199000000004f991199000000000000000000000000000000000000000000000
007007000000ff97c99991000000ff97c99991000000ff97c99991000000ff97c99991000000ff97c99991000000000000000000000000000000000000000000
00077000000004999fffff00000004999fffff00000004999fffff00000004999fffff00000004999fffff000000000000000000000000000000000000000000
0007700000000499fffff00000000499fffff00000000499fffff00000000499fffff00000000499fffff0000000000000000000000000000000000000000000
0070070000000049ff00000000000049ff00000000000049ff00000000000049ff00000000000049ff0000000000000000000000000000000000000000000000
00000000000000ddff000000000000ddff000000000000ddff000000000000ddff000000000000ddff0000000000000000000000000000000000000000000000
0000000000090cccdfd0000000090cccdfd0000000090dccdfd00000000900ccdfd000000000ccccdfd000000000000000000000000000000000000000000000
000000000099dccccd7c00000099dc99cd7c990000990ccccc990000009909c99d70000000099ccccd7909000000000000000000000000000000000000000000
00000000099949dcccc9000009994999ccc9990009990cc999990000099909499cc00000004999dcccc994000000000000000000000000000000000000000000
00000000099949ddccc9000009994444ccc4440009990cc44444000009990499ccc900000949999dccc440000100000000000000000000000000000000000000
000000000499491666690000049996166660000004999616666000000499964666600000099409966660000009f0000000000000000000000000000000000000
00000000004944d777740000004996d777700000004996d777700000004996d777900000049999d77770000009ff000000000009000000000000000000000000
00000000000496d767700000000496d767700000000496d767700000000496d764999000004444d799700000999ffdcccdddd999000000000000000000000000
000000000000449049000000000044904900000000004490490000000000499000494000000000999400000094444dcdd9966440000000000000000000000000
000000000000049949900000000004994990000000000499499000000000099000040000000000094990000090004dc444400000000000000000000000000000
