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

tr {
	display: flex;
	flex-direction: column;
	align-items: flex-start;
	justify-content: center;
	margin-bottom: 20px;
}

.inputStyle {
	width: 280px;
	height: 25px;
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
	
	// 삭제 버튼 클릭
	$("#btn-delete").click(function() {
		// 사용자가 입력한 사업장 정보를 저장할 formData 객체
		var formData = new FormData();
		formData.append("buNum", "${sessionScope.buNum}");
		formData.append("buPw", $("#buPw").val());
		
		if (confirm("삭제 하시겠습니까?")) {
			// ajax
			$.ajax({
				url : "${contextPath}/business/infoDelete",
				method : "POST",
				data : formData,
				contentType : false,
				processData : false,
				enctype : "multipart/form-data",
				success : function(msg) {
					if (msg === "ok") {
						alert("퇴점 처리 되었습니다.");
						location.href = "/business/mypage/restInfo";
					} else {
						alert("사업자번호 또는 비밀번호가 일치하지 않습니다.");
						location.href = "${contextPath}/business/mypage/restDelete";
					}
				},
				error : function() {
					alert("ajax Error");
				}
			});		// ajax
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
	
	
	
		<div id="myRestDelete">
			<table style="margin: 40px auto;">
				<tr>
					<td>사업자번호</td>
					<td><input type="text" id="buNum" class="inputStyle"></td>
				</tr>
				<tr>
					<td>비밀번호</td>
					<td><input type="password" id="buPw" class="inputStyle"></td>
				</tr>
			</table>
			
			<button type="button" id="btn-delete">삭제</button>
		</div>
		
	</c:if>
<!-- 입점신청 O -->
	
</div>



</body>
</html>