package com.games.learnspringframework.sample.Enterprises.business;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import com.games.learnspringframework.sample.Enterprises.DataService.DataServices;

@Component
public class BusinessServices {
	
	private DataServices dataServices;

	
	public BusinessServices(DataServices dataServices) {
		super();
		this.dataServices = dataServices;
	}


	public long CalculateSum() {
		List<Integer> reteriveData = dataServices.reteriveData();
		return reteriveData.stream().reduce(Integer::sum).get();
	}
}