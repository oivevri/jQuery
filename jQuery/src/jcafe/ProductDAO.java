package jcafe;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class ProductDAO {
	Connection conn;
	PreparedStatement pstmt;
	ResultSet rs;

	public ProductDAO() { // 생성자
		conn = common.ConnectDB.getConnection(); // 아니면 ConnectDB를 import 해서 common을 생략할수도있음
	}

	// 전체 조회하는 기능
	public List<ProductVO> getProductList() {
		List<ProductVO> list = new ArrayList<ProductVO>();

		String sql = "select * from product";
		try {
			pstmt = conn.prepareStatement(sql); // conn.~ 쓰면 트라이캐치 뜸
			rs = pstmt.executeQuery(); // 조회할때는 executeQuery()
			while (rs.next()) { // rs에 조회된 결과값이 있으면 아래를 루핑돌아
				// 가지고 온 값들을 List 컬렉션 list에 담자
				ProductVO vo = new ProductVO();
				vo.setAlt(rs.getString("alt"));
				vo.setCategory(rs.getString("category"));
				vo.setContent(rs.getString("content"));
				vo.setImage(rs.getString("image"));
				vo.setItem(rs.getString("item"));
				vo.setItemNo(rs.getString("item_no"));
				vo.setLikeIt(rs.getDouble("like_it"));
				vo.setLink(rs.getString("link"));
				vo.setPrice(rs.getDouble("price"));

				list.add(vo); // 조회한 값을 vo에 담는거
			}
		} catch (SQLException e) {
			e.printStackTrace();
		} finally { // 파이널 쓰고난뒤에
			try {
				conn.close(); // 이거쓰면 트라이캐치 뜸
			} catch (SQLException e) {
				e.printStackTrace();
			}
		}
		return list; // 리스트를 리턴
	}

	// 한건 조회하는 기능 // 검색기능
	public ProductVO getProduct(String itemNo) {
		String sql = "select * from product where item_no = ?";
		ProductVO vo = new ProductVO(); // 이거 if문안에있으면 그 사라지니까.. 리턴값으로 만들기위해 밖으로 뺀것
		try {
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, itemNo); // 위에서 미리설정해둔 sql문에서 첫번째 파라미터(첫번째 ?)에 itemNo를 넣어라
			rs = pstmt.executeQuery(); // 조회할때는 executeQuery()
			if (rs.next()) { // rs에 조회된 결과값이 있으면 아래를 루핑돌아

				vo.setAlt(rs.getString("alt"));
				vo.setCategory(rs.getString("category"));
				vo.setContent(rs.getString("content"));
				vo.setImage(rs.getString("image"));
				vo.setItem(rs.getString("item"));
				vo.setItemNo(rs.getString("item_no"));
				vo.setLikeIt(rs.getDouble("like_it"));
				vo.setLink(rs.getString("link"));
				vo.setPrice(rs.getDouble("price"));
			}
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			try {
				conn.close();
			} catch (SQLException e) {
				e.printStackTrace();
			}
		}
		return vo; // 조회된 데이터 하나를 리턴(없으면 null 인스턴스가 리턴됨)
	}
	// 한건 입력하는 기능
	public void insertProduct(ProductVO vo) { // ProductVo 타입의 인스턴스를 매개값으로 받아와서
		String sql = "insert into product (item_no, item, category, price, link, content, like_it, alt, image) " // 칼럼 쭉 적어준 다음 공백 한칸 두고 엔터치면 다음줄로 넘어가짐
				+ "values(?, ?, ?, ?, ?, ?, ?, ?, ?)";
		
		try {
			int r = 0; // 순서바뀔때를 대비해서 칼럼번호를 지정하지않고 그냥 변수 주고 돌기전에 ++시켜줌
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(++r, vo.getItemNo());
			pstmt.setString(++r, vo.getItem());
			pstmt.setString(++r, vo.getCategory());
			pstmt.setDouble(++r, vo.getPrice());
			pstmt.setString(++r, vo.getLink());
			pstmt.setString(++r, vo.getContent());
			pstmt.setDouble(++r, vo.getLikeIt());
			pstmt.setString(++r, vo.getAlt());
			pstmt.setString(++r, vo.getImage());
			
			r = pstmt.executeUpdate(); // 쿼리를 입력, 수정, 삭제할때는 executeUpdate()
			System.out.println(r + "건 입력됨");
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			try {
				conn.close();
			} catch (SQLException e) {
				e.printStackTrace();
			}
		}
		
	}
}
