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

.space {
	text-align: right;
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
	
	// 영업 open / close 버튼
	$("#btn-onoff").click(function() {
		var restOnoff = ${restInfo.restOnoff};
		var restId = "${sessionScope.buNum}";
		
		// 영업 전 -> 영업 중으로 변경
		if (restOnoff === 0) {
			if (confirm("가게를 OPEN 하시겠습니까?")) {
				$.ajax({
					url : "${contextPath}/business/onoff",
					type : "GET",
					data : { "restId" : restId, "restOnoff" : restOnoff },
					success : function(msg) {
						alert("영업 상태가 <영업 중>으로 변경되었습니다.");
						location.reload();
					}, 
					error : function() {
						alert("ajax Error");
					}
				});		// ajax
			}		// confrim if문
		} 
		
		// 영업 중 -> 영업 전으로 변경
		else {
			if (confirm("가게를 CLOSE 하시겠습니까?\n영업 전에는 대기를 받을 수 없습니다.")) {
				$.ajax({
					url : "${contextPath}/business/onoff",
					type : "GET",
					data : { "restId" : restId, "restOnoff" : restOnoff },
					success : function(msg) {
						alert("영업 상태가 <영업 전>으로 변경되었습니다.");
						location.reload();
					}, 
					error : function() {
						alert("ajax Error");
					}
				});		// ajax
			}		// confrim if문
		}
	});
	
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
	
	
	
		<div id="myRestInfo">
			
			<div id="myRestFile">
				<c:if test="${restInfo.restFile != null}">
					<c:forEach var="restImg" items="${fn:split(restInfo.restFile, '/')}">
						<img src="/business/showImg?img=${restImg}" width="200px" height="200px"> 
					</c:forEach>
				</c:if>
			</div>
			
			<table>
				<tr>
					<td>상호명</td>
					<td>${restInfo.restName}</td>
				</tr>
				<tr>
					<td>업종</td>
					<td>${restInfo.restCategory}</td>
				</tr>
				<tr>
					<td>소개</td>
					<td>${restInfo.restDescription}</td>
				</tr>
				<tr>
					<td>주소</td>
					<td>${fn:split(restInfo.restAddr, '/')[0]} ${fn:split(restInfo.restAddr, '/')[1]} ${fn:split(restInfo.restAddr, '/')[2]}</td>
				</tr>
				<tr>
					<td>전화번호</td>
					<td>${restInfo.restTel}</td>
				</tr>
				<tr>
					<td>사업자번호</td>
					<td>${restInfo.restId}</td>
				</tr>
				<tr>
					<td>영업시간</td>
					<td>
						<c:forEach var="runt" items="${fn:split(restInfo.restRuntime, '/')}">
							${runt}
							<c:if test="${runt == ' '}">기타 </c:if> <br>
						</c:forEach>
					</td>
				</tr>
				<tr>
					<td>편의시설</td>
					<td>
						<c:forEach var="con" items="${fn:split(restInfo.restConvenience, '/')}" varStatus="no">
							<img src="${pageContext.request.contextPath}/resources/img/${con}.png" width="70px"> 
						</c:forEach>
					</td>
				</tr>
				<tr>
					<td>대표 메뉴</td>
					<td><del>수정 예정!!</del></td>
				</tr>
				<tr>
					<td>영업 상태</td>
					<td>
						<c:choose>
							<c:when test="${restInfo.restStatus == 0}">입점 승인 대기 중입니다.</c:when>
							<c:when test="${restInfo.restStatus == 1}">
								<c:if test="${restInfo.restOnoff == 0}">
									<span style="color: red; font-weight: bold;">영업 전</span> <button type="button" id="btn-onoff" class="space">OPEN</button>
								</c:if>
								<c:if test="${restInfo.restOnoff != 0}">
									<span style="color: blue; font-weight: bold;">영업 중</span> <button type="button" id="btn-onoff" class="space">CLOSE</button>
								</c:if>
							</c:when>
							<c:when test="${restInfo.restStatus == 2}">관리자에 의해 제한되어있습니다. 문의 부탁드립니다.</c:when>
						</c:choose>
					</td>
				</tr>
				<tr>
					<td>공지사항</td>
					<td>${restInfo.restNotice}</td>
				</tr>
			</table>
		</div>
		
	</c:if>
<!-- 입점신청 O -->
	
</div>



</body>
</html>