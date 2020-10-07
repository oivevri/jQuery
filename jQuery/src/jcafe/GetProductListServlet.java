package jcafe;

import java.io.IOException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/GetProductListServlet")
// 처음 생성할때 url Mapping 에서 /GetProductListServlet 라고 된게, 이 파일의 경로를 최상위경로(/)인 WebContent로 해준거

public class GetProductListServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	public GetProductListServlet() {
		super();
	}

	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		response.setCharacterEncoding("utf-8"); // 한글나오게하려고 이거랑
		response.setContentType("text/html;charset=UTF-8"); // 이거 추가

		ProductDAO dao = new ProductDAO();
		List<ProductVO> list = dao.getProductList();

//		[{"item_no":"bean_001", "item":"콜롬비아원두", ...}, {}, {}] // 배열안에 오브젝트들을 이런식으로 넣어줘야함
//		String json = "[{\"item_no\":\"bean_001\"}]"; // 루핑돌면서 이렇게..

		int lastData = list.size(); // 데이터갯수 가져오는거
		int i = 0; // 루핑돌때마다 한개씩 증가시키도록 하자
		
		// 데이터 가져오기
		String json = "["; // 배열 열기
		for (ProductVO vo : list) { // 루핑돌면서 중괄호 안의 것들만 만들어주면 됨
			i++;
			json += "{\"item_no\":\"" + vo.getItemNo() + "\"" // 정렬할때 보기좋으라고 맨뒤에 주석표시하는거
					+ ",\"item\":\"" + vo.getItem() + "\"" //
					+ ",\"category\":\"" + vo.getCategory() + "\"" //
					+ ",\"price\":\"" + vo.getPrice() + "\"" //
					+ ",\"link\":\"" + vo.getLink() + "\"" //
					+ ",\"content\":\"" + vo.getContent() + "\"" //
					+ ",\"like_it\":\"" + vo.getLikeIt() + "\"" //
					+ ",\"alt\":\"" + vo.getAlt() + "\"" //
					+ ",\"image\":\"" + vo.getImage() + "\"" //
					+ " }";
			if (i != lastData) // i가 데이터갯수와 같지 않다면(총 데이터갯수보다 작은 값일때)
				json += ","; // 콤마를 추가해주자
		}
		json += "]"; // 닫기
		response.getWriter().append(json); // 화면에 출력되도록 하는것
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		doGet(request, response);
	}

}
