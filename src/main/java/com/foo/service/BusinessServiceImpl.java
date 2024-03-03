package com.foo.service;

import java.util.Random;

import javax.mail.internet.MimeMessage;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.stereotype.Service;

import com.foo.domain.BusinessusersVO;
import com.foo.domain.RestaurantmenusVO;
import com.foo.domain.RestaurantsVO;
import com.foo.persistence.BusinessDAO;

import net.nurigo.sdk.NurigoApp;
import net.nurigo.sdk.message.model.Message;
import net.nurigo.sdk.message.request.SingleMessageSendingRequest;
import net.nurigo.sdk.message.service.DefaultMessageService;

@Service
public class BusinessServiceImpl implements BusinessService {
	
	// 로거 생성
	private static final Logger logger = LoggerFactory.getLogger(BusinessServiceImpl.class);
	
	// 의존성 주입
	@Autowired
	private BusinessDAO bdao;
	@Autowired
	private JavaMailSender mailSender;
	private DefaultMessageService messageService;


	
	// ㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡ메서드 정의ㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡ
	
	
	
	// 1. 사업자 회원 가입
	@Override
	public void joinBuser(BusinessusersVO buvo) throws Exception {
		bdao.insertBuser(buvo);
	}
	
	// 1-1. 이메일 인증
	// 1-1-1. 랜덤 문자열 생성
	@Override
	public String randomString(int strLength) throws Exception {
		Random ran = new Random();
		StringBuffer buf = new StringBuffer();
		
		// 문자 인증
		if (strLength == 6) {
			String ranStr = "";
			for (int i = 0; i < strLength; i++) {
				ranStr += Integer.toString(ran.nextInt(10));
			}
			return ranStr;
		} 
		// 이메일 인증 (10자 이상)
		else {
			for (int i = 0; i < strLength; i++) {
				if (ran.nextInt(3) == 0) {	// 랜덤으로 뽑은 값이 0면 숫자 하나를 buffer에 추가
					buf.append(ran.nextInt(10));						// 0 ~ 9 까지 숫자 랜덤
				} else if (ran.nextInt(3) == 1) {
					buf.append((char)(ran.nextInt(26) + 65));		// A ~ Z 까지 소문자 랜덤
				} else {	// 랜덤으로 뽑은 boolean 값이 false면 숫자 하나를 buffer에 추가
					buf.append((char)(ran.nextInt(26) + 97));		// a ~ z 까지 소문자 랜덤
				}
			}
			
			return buf.toString();
		}
	}
	
	// 1-1-2. 이메일 양식
	@Override
	public String writeEmail(String email) throws Exception {
		String fromEmail = "mogwa.sitter@gmail.com";		// 보내는 메일(회사)
		String toEmail = email;								// 받는 메일
		String title = "FOOEATING 가입 인증 메일입니다.";	// 이메일 제목
		String ranStr = randomString(10);
		String content = 
				"<h1>FOOEATING 홈페이지를 방문해주셔서 감사합니다.</h1><br><br>" +
				"인증 번호는 " + ranStr + " 입니다.<br>" +
				"해당 인증번호를 인증번호 확인란에 기입하여 주십시오.";		// 이메일 내용
		
		sendEmail(fromEmail, toEmail, title, content);
		return ranStr;
	}
	
	// 1-1-3. 이메일 전송
	@Override
	public void sendEmail(String fromEmail, String toEmail, String title, String content) throws Exception {
		MimeMessage message = mailSender.createMimeMessage();
		
		MimeMessageHelper helper = new MimeMessageHelper(message, true, "utf-8");
		helper.setFrom(fromEmail);
		helper.setTo(toEmail);
		helper.setSubject(title);
		helper.setText(content, true);		// true로 설정 해야만 html 형식으로 전송. 작성하지 않으면 단순 텍스트로 전송됨.
		mailSender.send(message);
	}

	// 1-2. 사업자번호 중복 체크
	@Override
	public String bnumOverlap(String buNum) throws Exception {
		BusinessusersVO result = bdao.bnumOverlap(buNum);
		
		if (result == null) {
			logger.debug("$$$$$$$$$$$$$$$ 사업자번호 중복 X");
			return "1";
		} else {
			logger.debug("$$$$$$$$$$$$$$$ 사업자번호 중복 O");
			return "0";
		}
	}
	
	// 1-3. 휴대폰 번호 인증
	@Override
	public String sendSMS(String buTel) throws Exception {
		String apiKey = "";
		String apiSecretKey = "";
		this.messageService = NurigoApp.INSTANCE.initialize(apiKey, apiSecretKey, "https://api.coolsms.co.kr");
		
		String[] originTel = buTel.split("-");
		String toTel = originTel[0] + originTel[1] + originTel[2];
		logger.debug("$$$$$$$$$$$$$$$ totel : " + toTel);
		
		String ranStr = randomString(6);	// 문자 인증번호
		
		Message message = new Message();
		message.setFrom("01039805026");;	// 발신번호
		message.setTo(toTel);				// 수신번호
		message.setText("[FOOEATING] 본인확인 인증번호 (" + ranStr + ")를 입력하세요.");
		
		logger.debug("전송 response : " + this.messageService.sendOne(new SingleMessageSendingRequest(message)));
		
		return ranStr;
	}
	
	// 1-4. 회원 상태 저장
	@Override
	public void insertUserstatus(String userId, String buId) throws Exception {
		bdao.insertUserstatus(userId, buId);
	}
	
	
	
	// 2. 로그인
	@Override
	public BusinessusersVO loginBUser(BusinessusersVO buvo) throws Exception {
		return bdao.loginBUser(buvo);
	}
	
	
	
	// 3. 입점 신청
	@Override
	public void registRestaurant(RestaurantsVO revo) throws Exception {
		bdao.registRestaurant(revo);
	}
	
	// 3-1. 메뉴 등록
	@Override
	public void addMenu(RestaurantmenusVO rmvo) throws Exception {
	}
	
	
	
	// 4. 나의 가게 정보
	@Override
	public RestaurantsVO readMyRestaurantInfo(String restId) throws Exception {
		return bdao.readMyRestaurantInfo(restId);
	}
	
	// 4-1. 가게 수정
	@Override
	public void modifyRestaurant(RestaurantsVO revo) throws Exception {
		bdao.updateRestaurant(revo);
	}
	
	// 4-2. 가게 삭제
	@Override
	public int deleteRestaurant(BusinessusersVO buvo) throws Exception {
		return bdao.deleteRestaurant(buvo);
	}
	
	// 4-3. 가게 영업 상태 변경
	@Override
	public void modifyRestaurantOnoff(RestaurantsVO revo) throws Exception {
		bdao.updateRestaurantOnoff(revo);
	}

}
