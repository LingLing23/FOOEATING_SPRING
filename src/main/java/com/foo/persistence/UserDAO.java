package com.foo.persistence;
import com.foo.domain.UserVO;



public interface UserDAO {

	// 1. 회원 가입
	public void insertUser(UserVO vo);
	
}
