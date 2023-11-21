package com.games.learnspringframework.sample.Enterprises.DataService;

import java.util.Arrays;
import java.util.List;

import org.springframework.stereotype.Component;

@Component
public class DataServices {
	public List<Integer> reteriveData() {
		return Arrays.asList(12, 10, 20,67);
	}
}