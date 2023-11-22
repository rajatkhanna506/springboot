package com.games.learnspringframework.sample.Enterprises.web;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

import com.games.learnspringframework.sample.Enterprises.business.BusinessServices;

@RestController
public class Controller {

	
	private BusinessServices businessservice;

	public Controller(BusinessServices businessservice) {
		super();
		this.businessservice = businessservice;
	}

	@GetMapping("/sum")
	public long displaysum() {
		return businessservice.CalculateSum();
	}

}

// Business Layer
