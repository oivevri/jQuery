package jcafe;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/PostProductServlet")
public class PostProductServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    public PostProductServlet() {
        super();
    }

	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		ProductDAO dao = new ProductDAO();
		ProductVO vo = new ProductVO();
		
		String itemNo = request.getParameter("itemNo"); // 요청해서 itemNo 이름을 파라미터로 가진 값을 String itemNo로 담았음
		String item = request.getParameter("item");
		String category = request.getParameter("category");
		double price = Double.parseDouble(request.getParameter("price")); // 더블타입으로 형변환
		String content = request.getParameter("content");
		double likeIt = Double.parseDouble(request.getParameter("likeIt"));
		String image = request.getParameter("image");
// alt랑 link 없음.. -> 입력하는 칸에서 없으니까
		
		// 입력한 값을 vo의 필드에 각각 담아서
		vo.setAlt(item); // 화면에서 alt값이 없으니까 그냥 item 값으로 넘겨주는거
		vo.setLink("item.jsp"); // 링크는 위에서 따로안하고 item.jsp로 고정
		vo.setItemNo(itemNo);
		vo.setItem(item);
		vo.setCategory(category);
		vo.setPrice(price);
		vo.setContent(content);
		vo.setLikeIt(likeIt);
		vo.setImage(image);
		
		dao.insertProduct(vo); // 통합된 vo데이터를 insertProduct 메소드 호출해서 담아서 DB에 입력
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		doGet(request, response);
	}

}
