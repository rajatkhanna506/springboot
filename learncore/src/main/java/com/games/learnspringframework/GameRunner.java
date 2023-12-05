package com.games.learnspringframework;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

@Component
public class GameRunner {
	
	@Autowired
	private GamingConsole game;
	int ab;
	int xyz;
	int d;
	int hjh;
	

	public GameRunner(GamingConsole game) {
		this.game = game;

	}

	public void runGame() {
		game.up();
		game.down();
		game.left();
		game.right();
	}

}
