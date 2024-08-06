package bitcube.framework.ebid.dao;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageImpl;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Repository;

import bitcube.framework.ebid.etc.util.PagaUtils;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Repository
public class GeneralDao {
	
	@Autowired
	private SqlSession sqlSession;
	
	public Object selectGernalObject(String queryId, @SuppressWarnings("rawtypes") Map paramMap) throws Exception {
		return sqlSession.selectOne(queryId, paramMap);
	}
	
	public Object selectGernalCount(String queryId, @SuppressWarnings("rawtypes") Map paramMap) throws Exception {
		int cnt = (int)sqlSession.selectOne(queryId, paramMap);
		return cnt;
	}

	public int insertGernal(String queryId, @SuppressWarnings("rawtypes") Map paramMap) throws Exception {
		return sqlSession.insert(queryId, paramMap);
	}

	public int updateGernal(String queryId, @SuppressWarnings("rawtypes") Map paramMap) throws Exception {
		return sqlSession.update(queryId, paramMap);
	}

	public int deleteGernal(String queryId, @SuppressWarnings("rawtypes") Map paramMap) throws Exception {
		return sqlSession.delete(queryId, paramMap);
	}

	public List<Object> selectGernalList(String queryId, @SuppressWarnings("rawtypes") Map paramMap) throws Exception {
		List<Object> result = null;
		if (paramMap != null) {
			result = sqlSession.selectList(queryId, paramMap);
		} else {
			result = sqlSession.selectList(queryId);
		}
		return result;
	}
	
	@SuppressWarnings({"unchecked", "rawtypes"})
	public Page selectGernalListPage(String queryId, Map paramMap) throws Exception {
		int				count		= 0;
		List<Object>	list		= null;
		Pageable		pageable	= PagaUtils.pageable(paramMap);
		paramMap.put("offset", pageable.getOffset());
		paramMap.put("pageSize", pageable.getPageSize());
		
		count = sqlSession.selectOne(queryId + "_count", paramMap);
		list = sqlSession.selectList(queryId, paramMap);
		
		return new PageImpl<>(list, pageable, count);
	}
}

