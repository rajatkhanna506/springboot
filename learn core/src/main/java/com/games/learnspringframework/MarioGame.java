package com.games.learnspringframework;

import org.springframework.context.annotation.Primary;
import org.springframework.stereotype.Component;

@Component
public class MarioGame implements GamingConsole {

	@Override
	public void up() {
		System.out.println("up");

	}

	@Override
	public void down() {
		System.out.println("down");

	}

	@Override
	public void left() {
		System.out.println("left");

	}

	@Override
	public void right() {
		System.out.println("right");

	}
	
	@Override
	public void direction()
	{
	    System.out.println("directions");
	}
}
