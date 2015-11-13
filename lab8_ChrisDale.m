function lab8_ChrisDale
    p=5;
    switch p
        case 1
            p1();
        case 2
            p2()
        case 3
            p3()
        case 4
            p4()
        case 5
            p5()
    end
end

function p1()
    cube1=makeCube(20,20,20,5);
    cube2=makeCube(40,40,40,10);
    cube3=makeCube(60,60,60,15);
    plot_objects_3d(1,cube1,false,0,100,0,100,0,100,'p1 cube');
    plot_objects_3d(1,cube2,true,0,100,0,100,0,100,'p1 cube');
    plot_objects_3d(1,cube3,true,0,100,0,100,0,100,'p1 cube');
end

function p2()
    cube1=makeCube(20,20,20,10);
    plot_objects_3d(2,cube1,false,0,100,0,100,0,100,'p2 moving cube');
    waitforbuttonpress;
    time=2;
    inter=0.05;
    for t=0:inter:time
        cube1=translate(cube1,50,50,50,inter,time);
        plot_objects_3d(2,cube1,false,0,100,0,100,0,100,'p2 moving cube');
    end
end

function p3()
    cube1=makeCube(20,20,20,10);
    plot_objects_3d(3,cube1,false,0,100,0,100,0,100,'p3 moving and scaling cube');
    waitforbuttonpress;
    time=2;
    inter=0.05;
    x=[25 25];
    y=[25 25];
    z=[25 25];
%     sc=[3 -3];
    sc=[1.12 -1.12]; %can't get it to scale linearly
    for step=1:2
        for t=0:inter:time
            cube1=translate(cube1,x(step),y(step),z(step),inter,time);
            cube1=scale(cube1,sc(step),inter,time);
            plot_objects_3d(3,cube1,false,0,100,0,100,0,100,'p3 moving and scaling cube');
        end
        %waitforbuttonpress;
    end
end

function p4()
    cube1=makeCube(0,0,50,10);
    plot_objects_3d(4,cube1,false,-100,100,-100,100,-100,100,'p4 cube orbiting axis');
    cube1(1,:)=[0 0 0];
    waitforbuttonpress;
    time=7;
    inter=0.05;
    rX=7;
    rY=0;
    rZ=0;
    for t=0:inter:time
        cube1=rotate(cube1,rX,rY,rZ,inter,time);
        plot_objects_3d(4,cube1,false,-100,100,-100,100,-100,100,'p4 cube orbiting axis');
    end
end

function p5()
    cube1=makeCube(50,0,-50,10);
    cube1(1,:)=[0 0 0];
    cube2=makeCube(0,0,0,30);
    plot_objects_3d(5,cube1,true,-100,100,-100,100,-100,100,'p5 - 2 cubes orbiting');
    plot_objects_3d(5,cube2,true,-100,100,-100,100,-100,100,'p5 - 2 cubes orbiting');
    cube1(1,:)=[0 0 0];
    waitforbuttonpress;
    time=3;
    inter=0.01;
    rX1=5;
    rY1=0;
    rZ1=5;
    rX2=0;
    rY2=0;
    rZ2=-5;
    for t=0:inter:time
        cube1=rotate(cube1,rX1,rY1,rZ1,inter,time);
        cube2=rotate(cube2,rX2,rY2,rZ2,inter,time);
        plot_objects_3d(5,cube1,true,-100,100,-100,100,-100,100,'p5 - 2 cubes orbiting');
        plot_objects_3d(5,cube2,false,-100,100,-100,100,-100,100,'p5 - 2 cubes orbiting');
        pause(inter);
    end
end

function cube=makeCube(x,y,z,sideL)
    m=sideL/2;
    cube(1,:)=[x y z];
    %bottom
    cube(2,:)=[x-m y-m z-m];
    cube(3,:)=[x+m y-m z-m];
    cube(4,:)=[x+m y+m z-m];
    cube(5,:)=[x-m y+m z-m];
    cube(6,:)=[x-m y-m z-m];
    %top
    cube(7,:)=[x-m y-m z+m];
    cube(8,:)=[x+m y-m z+m];
    cube(9,:)=[x+m y+m z+m];
    cube(10,:)=[x-m y+m z+m];
	cube(11,:)=[x-m y-m z+m];
    %filling in other edges
    cube(12,:)=[x+m y-m z+m];%first
    cube(13,:)=[x+m y-m z-m];
    cube(14,:)=[x+m y+m z-m];%second
    cube(15,:)=[x+m y+m z+m];
    cube(16,:)=[x-m y+m z+m];%third
    cube(17,:)=[x-m y+m z-m];
end

function obj=translate(obj,x,y,z,inter,time)
    obj(:,1)=obj(:,1)+x*(inter/time);
    obj(:,2)=obj(:,2)+y*(inter/time);
    obj(:,3)=obj(:,3)+z*(inter/time);
end

function obj=scale(obj,scale,inter,time)
    len=length(obj);
    for objI=2:len
        obj(objI,:)=obj(objI,:)-obj(1,:);
        obj(objI,:)=obj(objI,:)*(scale*(inter/time)+1);
        %can't get it to scale linearly
        obj(objI,:)=obj(objI,:)+obj(1,:);
    end
end

function obj=rotate(obj,rX,rY,rZ,inter,time)
    rX=(inter/time)*rX*pi;
    rY=(inter/time)*rY*pi;
    rZ=(inter/time)*rZ*pi;
    roX=[1 0 0; 0 cos(rX) sin(rX); 0 -sin(rX) cos(rX)];
    roY=[cos(rY) 0 sin(rY); 0 1 0; -sin(rY) 0 cos(rY)];
    roZ=[cos(rZ) sin(rZ) 0; -sin(rZ) cos(rZ) 0; 0 0 1];
    len=length(obj);
    for objI=2:len
        obj(objI,:)=obj(objI,:)-obj(1,:);
        obj(objI,:)=obj(objI,:)*roX*roY*roZ;
        obj(objI,:)=obj(objI,:)+obj(1,:);
    end
end

function plot_objects_3d( figure_num, objects, draw_over, x_min, x_max, y_min, y_max, z_min, z_max, title_text )
    figure( figure_num );
    if draw_over,  hold on;  end;
    plot3( objects(2:end,1), objects(2:end,2), objects(2:end,3), 'LineWidth', 2 );
    if draw_over,  hold off;  end;
    axis equal;
    axis( [x_min x_max y_min y_max z_min z_max ]);
    title( title_text );
    grid on;
    xlabel('X');
    ylabel('Y');
    zlabel('Z');
    %axis off  % optional
end