<%--
  Created by IntelliJ IDEA.
  User: abclon
  Date: 2024-08-15
  Time: 오후 5:42
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head>
    <title>QnAList</title>
</head>
<style>
    body {
        font-family: Arial, sans-serif;
        margin: 20px;
        background-color: #f4f4f4;
    }
    table {
        width: 100%;
        border-collapse: collapse;
        margin-bottom: 20px;
    }
    th, td {
        padding: 12px;
        text-align: left;
        border-bottom: 1px solid #ddd;
    }
    th {
        background-color: #f4f4f4;
        font-weight: bold;
    }
    tr:hover {
        background-color: #f1f1f1;
    }
    .paging-container {
        text-align: center;
        margin-top: 20px;
    }
    .paging a {
        margin: 0 5px;
        padding: 8px 16px;
        text-decoration: none;
        color: #333;
        border: 1px solid #ddd;
        border-radius: 4px;
    }
    .paging-active {
        background-color: #007bff;
        color: #fff;
    }
    .search-container {
        display: flex;
        justify-content: space-between;
        margin-bottom: 20px;
    }
    .search-form select, .search-form input[type="text"] {
        padding: 8px;
        margin-right: 10px;
        border: 1px solid #ddd;
        border-radius: 4px;
    }
    .search-button {
        padding: 8px 16px;
        background-color: #007bff;
        color: #fff;
        border: none;
        border-radius: 4px;
        cursor: pointer;
    }
    .btn-write {
        padding: 8px 16px;
        background-color: #28a745;
        color: #fff;
        border: none;
        border-radius: 4px;
        cursor: pointer;
    }
    .btn-write i {
        margin-right: 5px;
    }
</style>
<script>
    let totalNoticeCnt = "${totalNoticeCnt}";
    console.log("totalNoticeCnt:"+totalNoticeCnt);
    /*let msg = "${msg}";
    if(msg=="DEL_OK") alert("게시글이 정상적으로 삭제되었습니다.");
    if(msg=="WRT_ERR") alert("게시물 등록에 실패하였습니다. 다시 시도해 주세요.");
    if(msg=="MOD_ERR") alert("게시물 수정에 실패하였습니다. 다시 시도해 주세요.");*/
</script>
<body>
<jsp:include page="../header.jsp" flush="true" />
<table>
    <tr>
        <th class="bno">번호</th>
        <th class="title">제목</th>
        <th class="writer">이름</th>
        <th class="reg_dt">등록일</th>
        <th class="view_cnt">조회수</th>
    </tr>
    <c:if test="${totalNoticeCnt!=null || totalNoticeCnt!=0}">
        <c:forEach var="qnaDto" items="${noticeList}">
            <tr>
                <td class="qna_bno"><b>공지</b></td>
                <td class="qna_title"><a href="<c:url value="/qna/read${ph.queryString}&bno=${qnaDto.bno}"/>"><b>${qnaDto.title}</b></a></td>
                <td class="qna_writer">${qnaDto.writer}</td>
                <td class="qna_reg_dt">${qnaDto.reg_dt}</td>
                <td class="qna_view_cnt">${qnaDto.view_cnt}</td>
            </tr>
        </c:forEach>
    </c:if>
    <c:forEach var="qnaDto" items="${list}">
        <tr>
            <td class="bno">${qnaDto.bno}</td>
            <td class="title">
                <c:if test="${qnaDto.depth !=0}">ㄴRE:</c:if>
                <a href="<c:url value="/qna/read${ph.queryString}&bno=${qnaDto.bno}"/>">${qnaDto.title}</a>
            </td>
            <td class="writer">${qnaDto.writer}</td>
            <td class="reg_dt">${qnaDto.reg_dt}</td>
            <td class="view_cnt">${qnaDto.view_cnt}</td>
        </tr>

    </c:forEach>
</table>
<br>
<div class="paging-container">
    <div class="paging">
        <c:if test="${totalCnt==null || totalCnt==0}">
            <div> 게시물이 없습니다. </div>
        </c:if>
        <c:if test="${totalCnt!=null && totalCnt!=0}">
            <c:if test="${ph.prevPage}">
                <a class="page" href="<c:url value="/qna/list${ph.getQueryString(ph.beginPage-1)}"/>">&lt;</a>
            </c:if>
            <c:forEach var="i" begin="${ph.beginPage}" end="${ph.endPage}">
                <a class="page ${i==ph.page? "paging-active" : ""}" href="<c:url value="/qna/list${ph.getQueryString(i)}"/>">${i}</a>
            </c:forEach>
            <c:if test="${ph.nextPage}">
                <a class="page" href="<c:url value="/qna/list${ph.getQueryString(ph.endPage+1)}"/>">&gt;</a>
            </c:if>
        </c:if>
    </div>
</div>

<div class="search-container">
    <form action="<c:url value="/qna/list"/>" class="search-form" method="get">
        <select class="option_date" name="option_date">
            <option value="week" ${sc.option_date=='week' ? "selected": ""}>일주일</option>
            <option value="month" ${sc.option_date=='month' ? "selected" : ""}>한달</option>
            <option value="month3" ${sc.option_date=='month3' ? "selected" : ""}>세달</option>
            <option value="all" ${sc.option_date=='all' || sc.option_date=='' ? "selected"  : ""}>전체</option>
        </select>
        <select class="option_key" name="option_key">
            <option value="titleContent" ${sc.option_key=='titleContent' || sc.option_key=='' ? "selected" : ""}>제목+내용</option>
            <option value="title" ${sc.option_key=='title' ? "selected" : ""}>제목만</option>
            <option value="writer" ${sc.option_key=='writer' ? "selected" : ""}>작성자</option>
        </select>

        <input type="text" name="keyword" class="search-input" type="text" value="${sc.keyword}" placeholder="검색어를 입력해주세요">
        <input type="submit" class="search-button" value="검색">
    </form>
    <button id="writeBtn" class="btn-write" onclick="location.href='<c:url value="/qna/write"/>'"><i class="fa fa-pencil"></i> 글쓰기</button>
</div>
<jsp:include page="../footer.jsp" flush="true" />
</body>
</html>