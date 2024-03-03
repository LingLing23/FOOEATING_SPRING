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

p {
	margin: 50px 0 20px 0;
}

.center {
	text-align: center;
}

.main {
	width: 75%;
	margin: 10px auto;
	box-sizing: border-box;
}

.info {
	display: grid;
	grid-template-columns: 50px auto;
	gap: 20px;
	column-gap: 20px;
}

.info-img {
	display: grid;
	grid-template-columns: repeat(7, 1fr);
	gap: 10px;
}

.tabs { 
 	margin: 50px auto;
 	padding-bottom: 40px;
 	background-color: #fff;
 	width: auto;
}

.tab_item {
	width: calc(100%/3);
	height: 50px;
	border-bottom: 3px solid #ffcc66;
	background-color: #f8f8f8;
	line-height: 50px;
	font-size: 16px;
	text-align: center;
	color: #333;
	display: block;
	float: left;
	text-align: center;
	font-weight: bold;
	transition: all 0.2s ease;
}

.tab_item:hover { opacity: 0.75; }

input[name="tab_item"] { display: none; }

.tab_content {
	display: none;
	padding: 40px 40px 0;
	clear: both;
	overflow: hidden;
	text-align: center;
}

#intro:checked ~ #intro-content, #review:checked ~ #review-content, 
#notice:checked ~ #notice-content { display: block; }

.tabs input:checked+.tab_item {
	background-color: #ffcc66;
	color: #fff;
}

</style>



<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.6.4/jquery.min.js"></script>
<script type="text/javascript">
$(document).ready(function() {
	
});
</script>

</head>
<body>



<!-- 헤더 -->
<div class="center">
	<a href="/main">
		<img src="${pageContext.request.contextPath}/resources/img/logo.png" width="200px" height="200px">
	</a>
	<h1>FOOEATING_Restaurant_Info</h1>
</div>
<!-- 헤더 -->



<div class="main">
	<!-- 상단 : 가게 사진, 가게 이름, 별점, 찜 -->
	<div class="div-top">
		<div class="slideshow">
			<c:if test="${restInfo.restFile != null}">
				<div class="mySlides fade">
					<c:forEach var="file" items="${fn:split(restInfo.restFile, '/')}">
						<img src="/business/showImg?img=${file}" height="400px" class="slideshow-image">
					</c:forEach>
				</div>
			</c:if>
		</div>
		
		<h1>${restInfo.restName}</h1>
		<div class="info">
			<div>⭐ 0</div>
			<div>💞 0</div>
		</div>
	</div>
	<!-- 상단 -->
	
	<hr>
	
	<!-- 중단 : 가게 정보, 편의시설, 메뉴, 가게소개/리뷰/공지사항 -->
	<div class="div-middle">
		<p>INFO</p>
		<div class="info">
			<div>🏷️</div>
			<div>${restInfo.restCategory}</div>
			<div>📍</div>
			<div>
				<c:forEach var="addr" items="${fn:split(restInfo.restAddr, '/')}">
					${addr} 
				</c:forEach>
			</div>
			<div>📞</div>
			<div>${restInfo.restTel}</div>
			<div>🕰️</div>
			<div>
				<c:forEach var="time" items="${fn:split(restInfo.restRuntime, '/')}">
					<c:if test="${!time.equals('기타 ')}">
						${time}<br>
					</c:if>
				</c:forEach>
			</div>
		</div>
		
		
		
		<p>CONVENIENCE</p>
		<div class="info-img">
			<c:forEach var="con" items="${fn:split(restInfo.restConvenience, '/')}">
				<div>
					<img src="${pageContext.request.contextPath}/resources/img/${con}.png" width="100px">
				</div>
			</c:forEach>
		</div>
		
		
		
		<p>MENU</p>
		<div class="info-grid">
			<div>대표 메뉴들...</div>
		</div>
		
		
		
		<p> </p>
		<div class="tabs">
			<input type="radio" name="tab_item" checked id="intro"><label class="tab_item" for="intro">INTRO</label>
			<input type="radio" name="tab_item" id="review"><label class="tab_item" for="review">REVIEW</label>
			<input type="radio" name="tab_item" id="notice"><label class="tab_item" for="notice">NOTICE</label>
			
			<div class="tab_content" id="intro-content">
				${restInfo.restDescription}
			</div>
			<div class="tab_content" id="review-content">
				작성된 리뷰가 없습니다.
			</div>
			<div class="tab_content" id="notice-content">
				${!restInfo.restNotice ? "공지사항이 없습니다." : restInfo.restNotice}
			</div>
		</div>
	</div>
	<!-- 중단 -->
	
	<hr>
	
	<!-- 하단 : 지도 -->
	<div class="div-bottom">
		<p>LOCATION</p>
		<div id="map" style="width:80%; height:300px; margin: 0 auto;"></div>
	</div>
	<!-- 하단 -->
</div>



<!-- 카카오맵 api -->
<script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=02702b58782cdab139188ebec921d82e&libraries=services,clusterer,drawing"></script>
<script type="text/javascript">

let addr = "${fn:split(restInfo.restAddr, '/')[1]}";

var geocoder = new kakao.maps.services.Geocoder();

geocoder.addressSearch(addr, function(result, status) {
	if (status === kakao.maps.services.Status.OK) {
		var center = new kakao.maps.LatLng(result[0].y, result[0].x);
		
		var mapContainer = document.getElementById('map');
		var mapOption = {
				center : center,
				level : 3
			};
		
		var map = new kakao.maps.Map(mapContainer, mapOption);
	}
	
	var marker = new kakao.maps.Marker({
		map: map,
		position: center
	});
});

</script>



</body>
</html>