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
}

.main {
	width: 100%;
}

.space {
	text-align: right;
}

.space>img {
	width: 70px;
	margin-right: 20px;
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
}

.tab::after {
	content: "";
	position: absolute;
	bottom: 0;
	left: 0;
	width: 0;
	height: 2px;
}

#gallery {
	width: 75%; margin-left: 10%; margin-right: 10%;
	display: grid;
	grid-template-columns: repeat(3, 1fr);
	grid-gap: 20px;
	justify-items: center;
	align-items: center;
}

.off {
	list-style-type: none;
	padding: 0px;
	margin-right: 0px;
	width: 100px; height: 70%;
	overflow: auto;
	position: fixed;
}

/* 마커 커스텀 오버레이 CSS */
.wrap {
	position: absolute;
	left: 0; bottom: 40px; width: 288px; height: 132px;
	margin-left: -144px;
	text-align: left;
	overflow: hidden; 
	font-size: 12px;
/* 	font-family: 'Malgun Gothic', dotum, '돋움', sans-serif; */
	line-height: 1.5;
}

.wrap * { padding: 0; margin: 0; }

.wrap .info {
	width: 286px; height: 120px;
	border-radius: 5px; border-bottom: 2px solid #ccc;
	border-right: 1px solid #ccc;
	overflow: hidden;
	background: #fff;
}

.wrap .info:nth-child(1) { border: 0; box-shadow: 0px 1px 2px #888; }

.info .title {
	padding: 5px 0 0 10px; height: 30px;
	background: #eee; border-bottom: 1px solid #ddd;
	font-size: 18px; font-weight: bold;
}

.info .close {
	position: absolute; color: #888;
	top: 4px; right: 15px; width: 23px; height: 23px;
}

.info .close:hover { cursor: pointer; }

.info .body { position: relative; overflow: hidden; }

.info .desc { position: relative; margin: 5px 0 0 90px; height: 75px; }

.desc .ellipsis { overflow: hidden; text-overflow: ellipsis; white-space: nowrap; }

.info .img {
	position: absolute;
	top: 6px; left: 5px; width: 73px; height: 71px;
	border: 1px solid #ddd; color: #888; overflow: hidden;
}

.info:after {
	content: ''; position: absolute; margin-left: -12px;
	left: 50%; bottom: 0; width: 22px; height: 12px;
	background: url('https://t1.daumcdn.net/localimg/localimages/07/mapapidoc/vertex_white.png')
}

.info .link { color: #5085BB; }

</style>



<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.6.4/jquery.min.js"></script>
<script type="text/javascript">

$(document).ready(function() {
	
	// 시도에 해당하는 시군구 데이터
	var cityData = {
			'서울' : ["강남구", "강동구", "강북구", "강서구", "관악구", "광진구", "구로구", "금천구", "노원구", "도봉구", "동대문구", "동작구", "마포구", "서대문구", "서초구", "성동구", "성북구", "송파구", "양천구", "영등포구", "용산구", "은평구", "종로구", "중구", "중랑구"],
		    '인천' : ["계양구", "남동구", "동구", "미추홀구", "부평구", "서구", "연수구", "중구"],
		    '부산' : ["강서구", "금정구", "남구", "동구", "동래구", "부산진구", "북구", "사상구", "사하구", "서구", "수영구", "연제구", "영도구", "중구", "해운대구"],
		    '대전' : ["대덕구", "동구", "서구", "유성구", "중구"],
		    '대구' : ["남구", "달서구", "달서군", "동구", "북구", "서구", "수성구", "중구"],
		    '울산' : ["남구", "동구", "북구", "중구", "울주군"],
		    '광주' : ["광산구", "남구", "동구", "북구", "서구"],
		    '제주' : ["서귀포시", "제주시"],
		    '세종' : ["세종특별자치시"],
		    '경기' : ["고양시", "과천시", "광명시", "광주시", "구리시", "군포시", "김포시", "남양주시", "동두천시", "부천시", "성남시", "수원시", "시흥시", "안산시", "안성시", "안양시", "양주시", "여주시", "오산시", "용인시", "의왕시", "의정부시", "이천시", "파주시", "평택시", "포천시", "하남시", "화성시", "가평군", "양평군", "연천군"],
		    '강원' : ["강릉시", "동해시", "삼척시", "속초시", "원주시", "춘천시", "태백시", "고성군", "양구군", "양양군", "영월군", "인제군", "정선군", "철원군", "평창군", "홍천군", "화천군", "횡성군"],
		    '경북' : ["경산시", "경주시", "구미시", "김천시", "문경시", "상주시", "안동시", "영주시", "영천시", "포항시", "고령군", "군위군", "봉화군", "성주군", "영덕군", "영양군", "예천군", "울릉군", "울진군", "의성군", "청도군", "청송군", "칠곡군"],
		    '경남' : ["거제시", "김해시", "밀양시", "사천시", "양산시", "진주시", "창원시", "통영시", "거창군", "고성군", "남해군", "산청군", "의령군", "창녕군", "하동군", "함안군", "함양군", "합천군"],
		    '전북' : ["군산시", "김제시", "남원시", "익산시", "전주시", "정읍시", "고창군", "무주군", "부안군", "순창군", "완주군", "임실군", "장수군", "진안군"],
		    '전남' : ["광양시", "나주시", "목포시", "순천시", "여수시", "강진군", "고흥군", "곡성군", "구례군", "담양군", "무안군", "보성군", "신안군", "영광군", "영암군", "완도군", "장성군", "장흥군", "진도군", "함평군", "해남군", "화순군"],
		    '충북' : ["제천시", "청주시", "충주시", "괴산군", "단양군", "보은군", "영동군", "옥천군", "음성군", "증평군", "진천군"],
		    '충남' : ["계룡시", "공주시", "논산시", "당진시", "보령시", "서산시", "아산시", "천안시", "금산군", "부여군", "서천군", "예산군", "청양군", "태안군", "홍성군"]
	}
	
	$("#addrSiDo").on("change", function() {
		let selectedCity = $(this).val();		// 선택된 시도 값
		let addrSiGunGu = $("#addrSiGunGu");	// 시군구 박스
		addrSiGunGu.empty();					// 기존의 선택된 시군구 값 제거
		addrSiGunGu.append('<option value="">' + (selectedCity !== '' ? selectedCity + ' 전체' : '지역을 선택해주세요.') + '</option>');
		
		let selectedCityData = cityData[selectedCity];	// 선택된 시도에 해당하는 시군구 배열 가져오기
		
		// 선택된 시군구 배열을 반복하며 옵션 추가
		if (selectedCity !== '') {
			for (var i = 0; i < selectedCityData.length; i++) {
				let siGunGu = selectedCityData[i];
				addrSiGunGu.append('<option value="' + siGunGu + '">' + siGunGu + '</option>');
			}
		}
	});
	
	
	
	// 검색 후 유지
	let urlParams = new URLSearchParams(window.location.search);
	let category = urlParams.get('category');
	let sido = urlParams.get('sido');
	let sigungu = urlParams.get('sigungu');
	let query = urlParams.get('query');
	
	if (category) {
		$("#category").val(category);
	}
	if (sido) {
		$("#addrSiDo").val(sido);
		
		$("#addrSiDo").on("change", function() {
			let selectedCity = $(this).val();		// 선택된 시도 값
			console.log(selectedCity);
			let addrSiGunGu = $("#addrSiGunGu");	// 시군구 박스
			addrSiGunGu.empty();					// 기존의 선택된 시군구 값 제거
			addrSiGunGu.append('<option value="">' + (selectedCity !== '' ? selectedCity + ' 전체' : '지역을 선택해주세요.') + '</option>');
			
			let selectedCityData = cityData[selectedCity];	// 선택된 시도에 해당하는 시군구 배열 가져오기
			
			// 선택된 시군구 배열을 반복하며 옵션 추가
			if (selectedCity !== '') {
				for (var i = 0; i < selectedCityData.length; i++) {
					let siGunGu = selectedCityData[i];
					addrSiGunGu.append('<option value="' + siGunGu + '">' + siGunGu + '</option>');
				}
			}
		});
		if (sigungu) {
			$("#addrSiGunGu").val(sigungu);
		} else {
			$("#addrSiGunGu").val();
		}
	}
	if (query) {
		$("#query").val(query);
	}
	
	
	
	// 기본 - 갤러리형 리스트 (지도형 숨기기)
	if (sessionStorage.getItem('listView') === 'mapTab') {
		$("#map").show();
		$("#gallery").hide();
	} else {
		$("#gallery").show();
		$("#map").hide();
	}
	
	// 갤러리형 탭 클릭
	$("#galleryTab").click(function() {
		$("#gallery").show();
		$("#map").hide();
		sessionStorage.setItem('listView', 'galleryTab');
	});
	
	// 지도형 탭 클릭
	$("#mapTab").click(function() {
		$("#map").show();
		$("#gallery").hide();
		sessionStorage.setItem('listView', 'mapTab');
	});
	
});



// 갤러리형 리스트에서 가게 클릭 시 상세 페이지 이동
function clickRest(restId) {
	location.href = '${contextPath}/restaurant/information?rest=' + restId;
}

</script>

</head>
<body>



<!-- 헤더 -->
<div class="center">
	<a href="/main">
		<img src="${pageContext.request.contextPath}/resources/img/logo.png" width="200px" height="200px">
	</a>
	<h1>FOOEATING_Restaurant_List</h1>
</div>
<!-- 헤더 -->



<!-- 검색 -->
<form id="searchForm" action="/restaurant/list" method="get">
	<div class="tabs">
		<div class="tab-nav">
			<div class="tab">업종
				<select id="category" name="category">
					<option value="">업종을 선택해주세요.</option>
					<option value="한식">한식</option>
					<option value="중식">중식</option>
					<option value="양식">양식</option>
					<option value="일식">일식</option>
					<option value="기타">기타</option>
					<option value="디저트">디저트</option>
				</select>
			</div>
			<div class="tab">
				시/도
				<select id="addrSiDo" name="sido">
					<option value="">지역을 선택해주세요.</option>
					<option value="서울">서울특별시</option>
					<option value="인천">인천광역시</option>
					<option value="부산">부산광역시</option>
					<option value="대전">대전광역시</option>
					<option value="대구">대구광역시</option>
					<option value="울산">울산광역시</option>
					<option value="광주">광주광역시</option>
					<option value="제주">제주특별자치도</option>
					<option value="세종">세종특별자치시</option>
					<option value="경기">경기도</option>
					<option value="강원">강원도</option>
					<option value="경북">경상북도</option>
					<option value="경남">경상남도</option>
					<option value="전북">전라북도</option>
					<option value="전남">전라남도</option>
					<option value="충북">충청북도</option>
					<option value="충남">충청남도</option>
				</select>
				시/군/구
				<select id="addrSiGunGu" name="sigungu">
					<option value="">지역을 선택해주세요.</option>
				</select>
			</div>
			<div class="tab"> 
				<input type="text" id="query" name="query" placeholder="상호명 또는 메뉴를 입력하세요.">
			</div>
			<div>
				<input type="submit" id="btnSearch" value="검색">
			</div>
		</div>
	</div>
</form>
<!-- 검색 -->



<!-- 갤러리형 / 지도형 선택 탭 -->
<div class="space">
	<img src="${pageContext.request.contextPath}/resources/img/menu.png" id="galleryTab">
	<img src="${pageContext.request.contextPath}/resources/img/map.png" id="mapTab">
</div>
<!-- 갤러리형 / 지도형 선택 탭 -->



<div class="main">
	<!-- 갤러리형 리스트 -->
	<div class="listDiv" id="gallery">
		
		<c:forEach var="gall" items="${restList}">
			<div class="galleryDiv" onclick="clickRest('${gall.restId}');">
				<c:if test="${gall.restFile != null}">
					<c:set var="gallFile" value="${fn:split(gall.restFile, '/')}"/>
					<img src="/business/showImg?img=${gallFile[0]}" width="200px" height="200px"> 
				</c:if>
				<br>
				${gall.restName}
			</div>
		</c:forEach>
		
	</div>
	<!-- 갤러리형 리스트 -->
	
	
	
	<!-- 지도형 리스트 -->
	<div class="listDiv" id="map">
		<div id="map" style="width:100%; height:500px;"></div>
	</div>
	<!-- 지도형 리스트 -->
	
	
	
	<!-- 오늘 휴무인 가게 리스트 -->
	<ul class="sideR" id="off">
		<li><b>TODAY CLOSE</b></li>
		<c:forEach var="list" items="${restList}">
			<c:if test="${list.restOnoff == 0}">
				<li>${list.restName}</li>
			</c:if>
		</c:forEach>
	</ul>
	<!-- 오늘 휴무인 가게 리스트 -->
</div>



<!-- 카카오맵 api -->
<script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=02702b58782cdab139188ebec921d82e&libraries=services,clusterer,drawing"></script>
<script>

var mapContainer = document.getElementById('map'),	// 지도를 표시할 div  
	mapOption = {
		center : new kakao.maps.LatLng(35.1795543, 129.0756416),	// 지도의 중심좌표 (부산시청)
		level : 8		// 지도의 확대 레벨
	};

var map = new kakao.maps.Map(mapContainer, mapOption);	// 지도 생성

// 가게 데이터
var listData = [];

<c:forEach var="rlist" items="${restList}" varStatus="no">
	var data = {};
	data.id = "${rlist.restId}";
	data.name = "${rlist.restName}";
	data.addr1 = "${fn:split(rlist.restAddr, '/')[0]}";
	data.addr2 = "${fn:split(rlist.restAddr, '/')[1]}";
	data.addr3 = "${fn:split(rlist.restAddr, '/')[2]}";
	data.file = "${fn:split(rlist.restFile, '/')[0]}";
	listData.push(data);
</c:forEach>

// 주소-좌표 변환 객체 생성
var geocoder = new kakao.maps.services.Geocoder();

for (let i = 0; i < listData.length; i++) {
	// 주소로 좌표 검색
	geocoder.addressSearch(listData[i].addr2, function(result, status) {
		// 검색 성공
// 		if (status === kakao.maps.service.Status.OK) {								// Status -> undefined 되어 에러 발생 (주석 처리)
			var coords = new kakao.maps.LatLng(result[0].y, result[0].x);
			listData[i].coder = coords.Ma + "," + coords.La;
			
			// 마커 생성
			var marker = new kakao.maps.Marker({
				map : map,						// 마커를 표시할 지도
				position : coords	// 마커의 위치
			});
			
			// 마커에 커스텀 오버레이 표시
			var overlay = new kakao.maps.CustomOverlay({
				position : marker.getPosition()
			});
			
			// 커스텀 오버레이 컨텐츠
			let customContent = document.createElement("div");									// 오버레이 컨텐츠 시작
			customContent.className = "wrap";
			
			let customInfo = document.createElement("div");										// 오버레이 컨텐츠 내용
			customInfo.className = "info";
			customContent.appendChild(customInfo);
			
			let customTitle = document.createElement("div");									// 오버레이 컨텐츠 타이틀
			customTitle.className = "title";
			customInfo.appendChild(customTitle);
			
			let customLink1 = document.createElement("a");
			customLink1.setAttribute("href", "${contextPath}/restaurant/information?rest=" + listData[i].id);
			customLink1.className = "link";
			customLink1.appendChild(document.createTextNode(listData[i].name));
			customTitle.appendChild(customLink1);
			
			let customClose = document.createElement("div");									// 오버레이 컨텐츠 닫기
			customClose.className = "close";
			customClose.setAttribute("title", "닫기");
			customClose.appendChild(document.createTextNode("X"));
			customClose.onclick = function() { overlay.setMap(null); };
			customTitle.appendChild(customClose);
			
			let customBody = document.createElement("div");										// 오버레이 컨텐츠 바디 시작
			customBody.className = "body";
			customInfo.appendChild(customBody);
			
			let customImgDiv = document.createElement("div");									// 오버레이 컨텐츠 이미지 div
			customImgDiv.className = "img";
			customBody.appendChild(customImgDiv);
			
			let customImg = document.createElement("img");										// 오버레이 컨텐츠 이미지 출력
			customImg.setAttribute("src", "/business/showImg?img=" + listData[i].file);
			customImg.setAttribute("width", "73");
			customImg.setAttribute("heigth", "70");
			customImgDiv.appendChild(customImg);
			
			let customDesc = document.createElement("div");										// 오버레이 컨텐츠 주소 시작
			customDesc.className = "desc";
			customBody.appendChild(customDesc);
			
			let customAddr = document.createElement("div");										// 오버레이 컨텐츠 주소 출력
			customAddr.className = "ellipsis";
			customAddr.appendChild(document.createTextNode(listData[i].addr1));
			customAddr.appendChild(document.createElement("br"));
			customAddr.appendChild(document.createTextNode(listData[i].addr2));
			customAddr.appendChild(document.createElement("br"));
			customAddr.appendChild(document.createTextNode(listData[i].addr3));
			customDesc.appendChild(customAddr);
			
			let customLink2Div = document.createElement("div");									// 오버레이 컨텐츠 길찾기
			customDesc.appendChild(customLink2Div);
			
			let customLink2 = document.createElement("a");										// 오버레이 컨텐츠 길찾기 링크
			customLink2.setAttribute("href", "https://map.kakao.com/link/to/" + listData[i].name + "," + listData[i].coder);
			customLink2.setAttribute("target", "_blank");
			customLink2.className = "link";
			customLink2.appendChild(document.createTextNode("길찾기"));
			customLink2Div.appendChild(customLink2);
			
			overlay.setContent(customContent);
			
			// 마커 클릭 시 해당 가게 오버레이
		 	kakao.maps.event.addListener(marker, 'click', function() {
		 		if (this.clickedOveray) {
		 			this.clickedOveray.setMap(null);
		 		}
		 		overlay.setMap(map);
		 		this.clickedOveray = overlay;
			});
			
		 	overlay.setMap(null);
// 		}																			// Status -> undefined 되어 에러 발생 (주석 처리)
	});
}

</script>



</body>
</html>