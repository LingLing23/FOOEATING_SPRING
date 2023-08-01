package com.foo.persistence;

import com.foo.domain.BusinessusersVO;
import com.foo.domain.RestaurantmenusVO;
import com.foo.domain.RestaurantsVO;

public interface BusinessDAO {
	
	// 1. 사업자 회원 가입
	public void insertBuser(BusinessusersVO buvo) throws Exception;
	
	// 2. 입점 신청
	public void registRestaurant(RestaurantsVO revo) throws Exception;
	
	// 2-1. 메뉴 등록
	public void insertMenu(RestaurantmenusVO rmvo) throws Exception;
	
}