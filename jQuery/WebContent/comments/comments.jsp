<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>comments.jsp</title>
<style>
	.form {
		border: 1px solid #FDFBF2;
		padding: 10px;
		background-color: #FDFBF2;
	}

	#line {
		border: 10px solid #F4E6A8;
		border-radius: 35px;
	}
	#commentList {
		border: 10px solid #528AA4;
		border-radius: 20px;
	}
	.comment {
		padding: 10px;
		border: 10px solid #DEEAEF;
		background-color: #F8FBFC;
	}
</style>
<script src="../js/jquery-3.5.1.min.js"></script>
<script>
	window.onload = function () { // 페이지(window)가 로딩되면
		loadCommentList();
	}
	// 목록조회
	function loadCommentList() {
		$.ajax({
			url: '../CommentsServ',
			data: 'cmd=selectAll', // 이렇게 파라미터로 적어도 되고 {cmd: 'selectAll'} 이렇게 자바스크립트의 object 타입으로 key-value 줘도됨.. 이건 CommentsServ.java에서 갖고온거
			dataType: 'xml',
			type: 'get',
			success: loadCommentResult, // 펑션에 콜백 함수만들어서 따로주자
			error: function(a, b) {
				alert('>>> ERROR: 댓글 로딩 실패: ' + b);
			}
		});
	}
	// 리스트 조회 콜백함수: 목록 결과 실행????? 뭐라고했지
	function loadCommentResult(xmlResult) {
		//console.log(xmlResult);
		let xmlDoc = xmlResult;
		
		// 이거 서블렛파일 열었을때 떴던걸 기준으로 태그 찾는거임
		let code = xmlDoc.getElementsByTagName('code').item(0).firstChild.nodeValue; // 한건이라도 무조건 배열형식으로 불러오고 첫번째인덱스로 찾아야함
		if (code == 'success') {
			let commentList = eval('(' + xmlDoc.getElementsByTagName('data').item(0).firstChild.nodeValue + ')'); // (eval라는 함수에 안에써진 값 그대로 평가?하겠다)
			console.log(commentList);
			let listDiv = $('#commentList');

			for(let i=0; i<commentList.length; i++){
				let commentDiv = makeCommentView(commentList[i]);
				listDiv.append(commentDiv);
			}
		}		
	}		
	// 댓글 볼수있는 화면
	function makeCommentView(cmt) { // cmt는 object
		let div = document.createElement('div'); // jQuery로는 $('<div />')
		div.setAttribute('id', 'c' + cmt.id); // object가 가진 id값을 더해서 div의 id 속성을 설정
		div.className = 'comment';
		div.comment = cmt; // {id:2, name:홍길동, commnet:내용, ...}
		
		let str = '<strong>' + cmt.name + '</strong> ' + cmt.content +
		' <input type="button" value="수정" onclick="viewUpdateForm(' + cmt.id + ')">' + // 클릭했을때 호출되는 viewUpdateForm에 매개값으로 cmt의 id값을 주기
		' <input type="button" value="삭제" onclick="confirmDeletion(' + cmt.id + ')">';
		div.innerHTML = str; // div 하위에 집어넣음
		return div;
		// cmt 값대로 받아서 div태그의 id값으로 주고, strong 태그에도, input태그에도 사용함
		// 결과를 div로 리턴
	}
	// 추가 등록 ajax 호출
	function addComment() {
		let name = document.addForm.name.value; // addForm의 name="name" 인 값을 불러와서..
		let content = document.addForm.content.value; 
		
		if(name == null || name == "") { // 이름이 null값이거나 공란이면
			alert('name is invalid');
			return; // 이 메세지만 띄워주고 끝? 다른값 리턴하지않고??
		} else if (content == null || content =="") {
			alert('content is invalid');
			return;
		}
		let params = 'name=' + name + '&content=' + content + '&cmd=insert';
		// 만약 한글이 깨진다면
		// let params = 'name=' + encodeURIComponent(name) + '&content=' + encodeURIComponent(content) + '&cmd=insert';
		$.ajax({
			url: '../CommentsServ',
			dataType: 'xml', // 입력시 리턴되는 타입이 xml?
			data: params, // 데이터가 많아서 변수 선언하고 따로뺌
			success: addResult, // 여기도 콜백함수 빼
			error: function(a, b) {
				alert('>>> ERROR: 서버 에러: ' + b);
			}
		});
	}
	// 댓글 등록 콜백함수
	function addResult(req) { // 저 위에 했던거랑 비슷함
		let xmlDoc = req;
		// 이거 서블렛파일 열었을때 떴던걸 기준으로 태그 찾는거임
		let code = xmlDoc.getElementsByTagName('code').item(0).firstChild.nodeValue; // 한건이라도 무조건 배열형식으로 불러오고 첫번째인덱스로 찾아야함
		
		if (code == 'success') {
			let comment = eval('(' + xmlDoc.getElementsByTagName('data').item(0).firstChild.nodeValue + ')'); // (eval라는 함수에 안에써진 값 그대로 평가?하겠다)
			let listDiv = document.getElementById('commentList');
			let commentDiv = makeCommentView(comment);
			listDiv.append(commentDiv);
			
			// 사람들이 입력한 값 지워지게(초기화)
			document.addForm.name.value = "";
			document.addForm.content.value = "";
			
			alert("[" + comment.id + '] 등록완료');
		}	
	}
	// 수정버튼 이벤트
	function viewUpdateForm(commentId) { // commentId 에 해당하는 값을 가져와서..
		let commentDiv = document.getElementById('c' + commentId);
		let updateFormDiv = document.getElementById('commentUpdate');	
		commentDiv.after(updateFormDiv); // 만든 수정폼이 각각 댓글 div의 뒤에 오도록
		
		let comment = commentDiv.comment; // {id: ??, name: ???, content: ???, ...}
		document.updateForm.id.value = comment.id;
		document.updateForm.name.value = comment.name;
		document.updateForm.content.value = comment.content;
		updateFormDiv.style.display ='block';
	}
	// 변경/저장 : 수정 칸의 변경 버튼 눌렀을때 
	 function updateComment() {
		let id = document.updateForm.id.value;
		let name = document.updateForm.name.value;
		let content = document.updateForm.content.value;
		let params = "id=" + id + "&name=" + name + "&content=" + content + "&cmd=update";
		$.ajax({
			url: '../CommentsServ', // 얘랑(서브릿)
			data: params, // 얘가(데이터) DB처리
			dataType: 'xml', // 리턴된 결과값
			success: updateResult, // 콜백함수
			error: function(a, b){
				alert('>>> ERROR: 서버 에러: ' + b);
			}
		});
	}
	// 변경 콜백함수 -> 댓글 등록 콜백함수랑 거의 유사
	function updateResult(req) {
		let xmlDoc = req;
		
		let code = xmlDoc.getElementsByTagName('code').item(0).firstChild.nodeValue; // 한건이라도 무조건 배열형식으로 불러오고 첫번째인덱스로 찾아야함
		
		if (code == 'success') { // 버튼눌렀을때 success 되면 변경된 값을 넘겨줌
			let comment = eval('(' + xmlDoc.getElementsByTagName('data').item(0).firstChild.nodeValue + ')'); // (eval라는 함수에 안에써진 값 그대로 평가?하겠다)
			let listDiv = document.getElementById('commentList');
			let commentDiv = makeCommentView(comment);
			
			let oldCommentDiv = document.getElementById('c' + comment.id); // 기존정보
			
			// 보여져야 할 것은 listDiv고, 거기를 변경(대체)한다
			listDiv.replaceChild(commentDiv, oldCommentDiv);
			
			document.getElementById('commentUpdate').style.display = 'none'; // 다시 수정칸이 안보이게
			
			alert("[" + comment.id + '] 수정완료');
		}
	}
	// 취소 : 수정 칸의 취소 버튼 눌렀을때
	function cancelUpdate() {
		document.getElementById('commentUpdate').style.display = 'none'; // 다시 수정칸이 안보이게
	}
	// 삭제 이벤트
	function confirmDeletion(id) {
		$.ajax({
			url: '../CommentsServ',
			data: 'id=' + id + '&cmd=delete',
			dataType: 'xml',
			success: deleteResult,
			error: function(a, b){
				alert('>>> ERROR: 서버 에러: ' + b);
			}
		});
	}
	// 삭제 콜백함수
	function deleteResult(req) {
		let xmlDoc = req;
		let code = xmlDoc.getElementsByTagName('code').item(0).firstChild.nodeValue; // 한건이라도 무조건 배열형식으로 불러오고 첫번째인덱스로 찾아야함
		
		if (code == 'success') { // 버튼눌렀을때 success 되면 변경된 값을 넘겨줌
			let comment = eval('(' + xmlDoc.getElementsByTagName('data').item(0).firstChild.nodeValue + ')'); // (eval라는 함수에 안에써진 값 그대로 평가?하겠다)
			let listDiv = document.getElementById('commentList');
			
			let commentDiv = document.getElementById('c' + comment.id);
			listDiv.removeChild(commentDiv);
			
			alert("삭제되었습니다");
		}
	}
	
</script>
</head>
<body>
	<div id='line'>
		<div id='commentList'></div>
	</div>
	<p style="height: 50px" />
	
	<!-- 글 등록/추가 화면 -->
	<div id='commentAdd'>
		<form action="" name="addForm" class="form">
			이름: <input type="text" name="name" size="10"><p />
			내용: <textarea name="content" rows="2" cols="20"></textarea><p />
			<input type="button" value="등록" onclick="addComment()">
		</form>
	</div>
	
	<!-- 글 수정 화면 -->
	<div id='commentUpdate' style="display: none;">
		<form action="" name="updateForm" class="form">
			<input type="hidden" name="id" value="">
			이름: <input type="text" name="name" size="10"><p />
			내용: <textarea name="content" rows="2" cols="20"></textarea><p />
			<input type="button" value="변경" onclick="updateComment()">
			<input type="button" value="취소" onclick="cancelUpdate()">
		</form>
	</div>
	
	
	
	
</body>
</html>