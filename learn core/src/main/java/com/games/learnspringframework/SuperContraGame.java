package com.games.learnspringframework;

import org.springframework.context.annotation.Primary;
import org.springframework.stereotype.Component;

@Component
@Primary
public class SuperContraGame implements GamingConsole {

	public void up() {
		System.out.println("super up");

	}

	public void down() {
		System.out.println("super down");

	}

	public void left() {
		System.out.println("super left");

	}

	public void right() {
		System.out.println("super right");

	}
	

    public void direction()
    {
        System.out.println("directions");
    }
}
