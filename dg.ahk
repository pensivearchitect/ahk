/*
People are under the impression that this script was made by Cat | Josh, this impression is false
All credit should be given to Wicked, of xp-waste.com
*/
SetMouseDelay, -1
#SingleInstance force

mouseclickleft(px3,py3,px4=0,py4=0,relative=0,speed=1){
   mousemove(px3,py3,px4,py4,relative,speed)
   dllcall("mouse_event", "UInt", 0x02)
   dllcall("mouse_event", "UInt", 0x04)
}

mouseclickright(px3,py3,px4=0,py4=0,relative=0,speed=1){
   mousemove(px3,py3,px4,py4,relative,speed)
   dllcall("mouse_event", "UInt", 0x08)
   dllcall("mouse_event", "UInt", 0x10)
}

mousemove(px3,py3,px4=0,py4=0,relative=0,speed=1){
   if(isnan(px3)||isnan(py3)||isnan(px4)||isnan(py4)||isnan(relative)||isnan(speed))  ;~ Check that paramters are the correct type
      return ;~ If they aren't, end the function
   batchlines:=a_batchlines ;~ Get current batch lines to restore later
   setbatchlines,-1 ;~ Set batch lines to -1 for smoother movements
   varsetcapacity(p0,8) ;~ Set the capacity of the pointer which will hold the current mouse position
   dllcall("GetCursorPos","Uint",&p0) ;~ Store the current mouse position in 
   px0:=numget(p0,0,"Int") ;~ Get the current x position
   py0:=numget(p0,4,"Int") ;~ Get the current y position
   px3:=px4!=0 ? nrand(px3,px4):px3  ;~ If a random area is desired, chose a random x coordinate in that area
   py3:=py4!=0 ? nrand(py3,py4):py3  ;~ If a random area is desired, chose a random y coordinate in that area
   if relative  ;~ If the mouse movement will be relative of it's current position
   {
      px3:=px0+px3 ;~ Offset the desired x coordinate by the current position
      py3:=py0+py3 ;~ Offset the desired y coordinate by the current position
   }
   px2:=nrand(px1:=nrand(px0,px3),px3) ;~ Chose two random x coordinates from px0 and px3 or the mouse to pass through
   py2:=nrand(py1:=nrand(py0,py3),py3) ;~ Chose two random y coordinates from py0 and py3 or the mouse to pass through
   segments:=(segments:=sqrt(abs(px3-px0)**2+abs(py3-py0)**2))>speed ? speed:segments ;~ Calculate the distance from px0,py0 to px3,py3
   p:=bezier(px0,py0,px1,py1,px2,py2,px3,py3,segments) ;~ Store the coordinates of the cubic bezier path in the object p (p.x[#] and p.y[#])
   start:=a_tickcount ;~ Get the starting time of the mouse movements
   loop, % segments-1 ;~ Loop the distance from px0,py0 to px3,py3
   {
      dllcall("SetCursorPos",int,p.x[a_index-1],int,p.y[a_index-1]) ;~ Move the mouse to the correct position along the bezier path
      dllcall("Sleep",UInt,(delay:=(speed-(a_tickcount-start))/(segments-a_index))>=1 ? delay:1) ;~ Calculate the sleep length based on distance left to travel and time remaining
   }
   dllcall("SetCursorPos",int,px3,int,py3) ;~ Ensure the mouse is at the final position
   setbatchlines,% batchlines ;~ Restore the previous batch line settings
}

bezier(px0,py0,px1,py1,px2,py2,px3,py3,segments) {
   o:=[x,y]
   loop,% segments-1
      o.x[a_index-1]:=px0*(u:=1-t:=a_Index/segments)**3+3*px1*t*u**2+3*px2*u*t**2+px3*t**3,o.y[a_index-1]:=py0*u**3+3*py1*t*u**2+3*py2*u*t**2+py3*t**3
   return o
}

isnan(x){
   if x is number
      return false
   return true
}

nrand(x,y){
   f:=a_formatfloat
   setformat,float,0.6
   loop 12
      n+=rand(0.0,1)
   setformat,float,% f
   return (z:=((y>x ? y:x)+(x<y ? x:y))/2+((n-6)*((y>x ? y:x)-(x<y ? x:y)))/6)<(y>x ? y:x) ? z<(x<y ? x:y) ? (x<y ? x:y):z:(y>x ? y:x)
}

rand(x,y){
   random,v,% x,% y
   return v
}


!w::
mouseclickright(0,0,0,0,true)
mouseclickleft(0,40,0,0,true)
mousemove(0,-40,0,0,true)
return

!e::
mouseclickright(0,0,0,0,true)
mouseclickleft(0,80,0,0,true)
mousemove(0,-80,0,0,true)
return

!q::
mouseclickleft(0,0,0,0,true)
mouseclickleft(0,40,0,0,true)
mousemove(0,-40,0,0,true)
