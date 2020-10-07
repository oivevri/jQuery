<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>item.jsp</title>
<style>
td {
	padding: 10px;
}
.td {
	text-align: center;
	background-color: lightblue;
}
</style>
<script src="../js/jquery-3.5.1.min.js"></script>
</head>
<body>
	<table border="1" style="border-collapse: collapse;">
		<tr>
			<td class="td">Item No</td>
			<td><input type="text" name="itemNo"></td>
		</tr>
		<tr>
			<td class="td">Item</td>
			<td><input type="text" name="item"></td>
		</tr>
		<tr>
			<td class="td">Category</td>
			<td><input type="text" name="category"></td>
		</tr>
		<tr>
			<td class="td">Price</td>
			<td><input type="text" name="price"></td>
		</tr>
		<tr>
			<td class="td">Content</td>
			<td><input type="text" name="content"></td>
		</tr>
		<tr>
			<td class="td">Like It</td>
			<td id="likeIt" name="likeIt" style='font-size:20px;'></td>
			<!-- 별은 input 말고 그냥 td태그 이용해야 이모지 뜬다,,-->
		</tr>
		<tr>
			<td class="td">Image</td>
			<td><img id="image"></td>
		</tr>
	</table>
<!-- product.html에서 href 넘길때 'item.jsp?itemNo=', 즉 파라미터 itemNo 사용해서 넘기니까 여기 밑에서 getParameter("itemNo") 쓴거 -->
	<%
		String itemNo = request.getParameter("itemNo");
	%>
	<script>
		$.ajax({
			url: '../GetProductServlet',
			data: {itemNo: "<%=itemNo%>"},
			// 위에 data에서 페이지 호출했을때 말하는 아이템넘버가 뭔지 알려줘야함 < % 는 자바문법임을 알려주는거
			dataType: 'json',
			success: function (result) {
				let data = result;
				console.log(data);
				// 잘모르겠으면 console.log(data); 해서 확인해보면 됨
				
				// 별 조건문 밑에있으면 안돼서 여기에..
				let star = '';
			    let cnt = Math.floor(data[0].likeIt);
			    for (let i = 0; i < cnt; i++) {
			        star += '&#128516;';
			    }
			    let half = data[0].likeIt - cnt;
			    if (half) {
			        star += '&#128528;';
			    }
				
				
				// DB에 값 넣어주기
				// 왜 data[0]이냐면, data 항목에서 0번째 인덱스값이 내가 클릭한 자료라서(itemNo로 찾은..)
				$('input[name="itemNo"]').val(data[0].itemNo); // 인풋칸에서 가져온 값들을 거기에 넣어주는거
				$('input[name="item"]').val(data[0].item);
				$('input[name="category"]').val(data[0].category);
				$('input[name="price"]').val(data[0].price);
				$('input[name="content"]').val(data[0].content);
				$('#likeIt').html(star); // 여기에 val 말고 html 해줘야지 뜸!
				$('#image').attr('src', '../images/' + data[0].image).attr('width', '300px');
			},
			error: function (result) {
				console.log(">>> error");
				console.log("-------------------------------------");
				console.log(result);
			}
		});
	
	</script>
</body>
</html>