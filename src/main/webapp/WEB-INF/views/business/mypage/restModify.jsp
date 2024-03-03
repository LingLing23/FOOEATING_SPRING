<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>

<style>

td {
	box-sizing: border-box;
	padding-right: 20px;
	padding-bottom: 20px;
}

.center {
	text-align: center;
}

.btn {
	text-align: right;
}

.btnstyle {
	width: 100px;
	height: 30px;
}

.sidebar {
	width: 25%;
	float: left;
	box-sizing: border-box;
}

.main {
	width: 75%;
	float: right;
	box-sizing: border-box;
}

.tabs { 
 	display: flex;
 	justify-content: left;
 	width: 100%;
 	background-color: #fff;
 	margin-bottom: 30px;
}

.tabs>* {
	margin: 0;
	padding: 0;
	list-style-type: none;
	box-sizing: border-box;
}

.tab-nav {
	display: flex;
	justify-content: center;
	align-items: center;
	margin-top: 20px;
}

.tab {
	position: relative;
	padding: 10px 15px;
	color: #151b26;
	background-color: transparent;
	cursor: pointer;
}

.tab::after {
	content: "";
	position: absolute;
	bottom: 0;
	left: 0;
	width: 0;
	height: 2px;
	background-color: #ffcc66;
	transition: width 300ms ease-out;
}

.tab:hover::after {
	width: 100%;
}

</style>



<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.6.4/jquery.min.js"></script>
<script type="text/javascript">

$(document).ready(function() {
	
	// 영업시간 요일 체크 시 시간 작성 활성화
	var dayValue;
	$("input[name='restRuntime']").click(function() {
		dayValue = $(this).val();
		
		if ($(this).prop('checked')) {
			$("#time1" + dayValue).prop('disabled', false);
			$("#time2" + dayValue).prop('disabled', false);
			$("#time8" + dayValue).prop('disabled', false);
		} else {
			$("#time1" + dayValue).prop('disabled', true);
			$("#time2" + dayValue).prop('disabled', true);
			$("#time8" + dayValue).prop('disabled', true);
		}
	});
	
	// 수정 버튼 클릭
	$("#btn-modify").click(function() {
		// 사용자가 입력한 사업장 정보를 저장할 formData 객체
		var formData = new FormData();
		formData.append("restId", "${sessionScope.buNum}");
		
		// 사진 저장
		var files = $("#restFile")[0].files;
		for (var i = 0; i < files.length; i++) {
			formData.append("files", files[i]);
		}
		
		// 소개 저장
		formData.append("restDescription", $("#restDescription").val());
		
		// 영업시간 저장
		var runArr = [ "일요일 휴무", "월요일 휴무", "화요일 휴무", "수요일 휴무", "목요일 휴무", "금요일 휴무", "토요일 휴무", "기타 " ];
		var newRun = "";
		$.each(runArr, function(i, e) {
			$("input[name='restRuntime']:checked").each(function() {
				dayValue = $(this).val();
				
				if (e.includes(dayValue)) {
					runArr[i] = (i != 7) ?  
						dayValue + " " + document.getElementById("time1" + dayValue).value + " ~ " + document.getElementById("time2" + dayValue).value :
							dayValue + " " + $("#time8기타").val();
				}
			});
			newRun += (i !== runArr.length - 1 ? runArr[i] + "/" : runArr[i]);
		});		// each
		formData.append("restRuntime", newRun);
		
		// 편의시설 저장
		var newCon = ""
		$("input[name='restConv']:checked").each(function() {
			newCon += $(this).val() + "/";
		});
		formData.append("restConvenience", newCon.slice(0, -1));
		
		// 공지사항 저장
		formData.append("restNotice", $("#restNotice").val());
		
		if (confirm("수정 하시겠습니까?")) {
			// ajax
			$.ajax({
				url : "${contextPath}/business/infoModify",
				method : "POST",
				data : formData,
				contentType : false,
				processData : false,
				enctype : "multipart/form-data",
				success : function(msg) {
					alert("수정이 완료되었습니다. :)");
					location.href = "/business/mypage/restInfo";
				},
				error : function() {
					alert("ajax Error");
				}
			});		// ajax
		} 
	});		// 수정버튼
	
});

</script>

</head>
<body>



<c:if test="${empty sessionScope.buId}">
	<c:redirect url="/main"/>
</c:if>



<!-- 헤더 -->
<div class="center">
	<a href="/main">
		<img src="${pageContext.request.contextPath}/resources/img/logo.png" width="200px" height="200px">
	</a>
	<h1>FOOEATING_Mypage_RestaurantInfo</h1>
</div>
<!-- 헤더 -->



<!-- 사이드바_사업자 -->
<div class="sidebar">
	<c:import url="sidebarB.jsp" />
</div>
<!-- 사이드바_사업자 -->


<div class="main">
	
<!-- 입점신청 X -->
	<c:if test="${restInfo == null}">
	
		등록된 가게가 없습니다. <br>
		<button type="button" id="goRegistration" onclick="location.href = '/business/registration';">&gt; 입점 신청하기</button>
	
	</c:if>
<!-- 입점신청 X -->



<!-- 입점신청 O -->
	<c:if test="${restInfo != null}">
		
	<!-- 상단 탭 -->
		<div class="tabs">
			<ul class="tab-nav">
				<li class="tab" onclick="location.href = '${contextPath}/business/mypage/restInfo';">나의 가게 정보</li>
				<li class="tab" onclick="location.href = '${contextPath}/business/mypage/restModify';">정보 수정</li>
				<li class="tab" onclick="location.href = '${contextPath}/business/mypage/restDelete';">가게 삭제</li>
			</ul>
		</div>
	<!-- 상단 탭 -->
	
	
	
		<div id="myRestModify">
			
			<div id="myRestFile">
				사진 
				<input type="file" id="restFile" multiple>
			</div>
			
			<table>
				<tr>
					<td>소개</td>
					<td><textarea rows="7" cols="50" id="restDescription" placeholder="소개글을 작성해주세요.">${restInfo.restDescription}</textarea></td>
				</tr>
				<tr>
					<td>영업시간</td>
					<td>
						<c:forEach var="runt" items="${fn:split(restInfo.restRuntime, '/')}" varStatus="no">
							<c:set var="day" value="${fn:substring(runt, 0, 3)}" />
							<c:set var="time" value="${fn:substring(runt, 4, fn:length(runt))}" />
							
							<c:if test="${no.index < 7}">
								<input type="checkbox" name="restRuntime" value="${day}" <c:if test="${!time.equals('휴무')}">checked</c:if>> ${day} 
								<input type="time" id="time1${day}" <c:if test="${time.equals('휴무')}">disabled</c:if> value="${fn:substring(time, 0, 5)}"> 
								~ <input type="time" id="time2${day}" <c:if test="${time.equals('휴무')}">disabled</c:if> value="${fn:substring(time, 8, 13)}"> <br>
							</c:if>
								
							<c:if test="${no.index == 7}">
								<input type="checkbox" name="restRuntime" value="기타"> 기타 
								<input type="text" id="time8기타" <c:if test="${day != '기타 '}">value="${runt}"</c:if> placeholder="기타 공휴일을 입력하세요." disabled>
							</c:if>
						</c:forEach>
					</td>
				</tr>
				<tr>
					<td>편의시설</td>
					<td>
						<c:forEach var="con" items="${fn:split('와이파이/화장실분리/노키즈존/단체석/반려동물/주차/포장', '/')}" varStatus="no">
							<input type="checkbox" name="restConv" id="chkCon${con}" <c:if test="${fn:contains(restInfo.restConvenience, con)}">checked</c:if> value="${con}"> ${con}
							<img src="${pageContext.request.contextPath}/resources/img/${con}.png" width="70px"> 
							<c:if test="${no.count % 2 == 0}"><br></c:if>
						</c:forEach>
					</td>
				</tr>
				<tr>
					<td>대표 메뉴</td>
					<td><del>수정 예정!!</del></td>
				</tr>
				<tr>
					<td>공지사항</td>
					<td>
						<textarea rows="7" cols="50" id="restNotice" placeholder="공지사항">${restInfo.restNotice}</textarea>
					</td>
				</tr>
			</table>
			
			<button type="button" id="btn-modify">수정</button>
			
		</div>
		
	</c:if>
<!-- 입점신청 O -->
	
</div>



</body>
</html>