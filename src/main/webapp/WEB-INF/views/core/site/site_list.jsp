<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fnx" uri="http://java.sun.com/jsp/jstl/functionsx" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="f" uri="http://www.jspxcms.com/tags/form" %>
<%@ taglib prefix="shiro" uri="http://shiro.apache.org/tags" %>
<%@ taglib prefix="tags" tagdir="/WEB-INF/tags" %>
<!DOCTYPE html>
<html>
<head>
    <jsp:include page="/WEB-INF/views/head.jsp"/>
    <script type="text/javascript">
        $(function () {
            $("#importForm").validate();
            $("#sortHead").headSort();
        });
        function confirmDelete() {
            return confirm("<s:message code='confirmDelete'/>");
        }
        function optSingle(opt) {
            if (Cms.checkeds("ids") == 0) {
                alert("<s:message code='pleaseSelectRecord'/>");
                return false;
            }
            if (Cms.checkeds("ids") > 1) {
                alert("<s:message code='pleaseSelectOne'/>");
                return false;
            }
            var id = $("input[name='ids']:checkbox:checked").val();
            location.href = $(opt + id).attr("href");
        }
        function optDelete(form) {
            if (Cms.checkeds("ids") == 0) {
                alert("<s:message code='pleaseSelectRecord'/>");
                return false;
            }
            if (!confirmDelete()) {
                return false;
            }
            form.action = 'delete.do';
            form.submit();
            return true;
        }
    </script>
</head>
<body class="skin-blue content-body">
<jsp:include page="/WEB-INF/views/commons/show_message.jsp"/>
<div class="content-header">
    <h1><s:message code="site.management"/> - <s:message code="list"/>
        <small>(<s:message code="totalElements" arguments="${fn:length(list)}"/>)</small>
    </h1>
</div>
<div class="content">
    <div class="box box-primary">
        <div class="box-body table-responsive">
            <form class="form-inline ls-search" action="list.do" method="get">
                <div class="form-group">
                    <label><s:message code="site.name"/></label>
                    <input class="form-control input-sm" type="text" name="search_CONTAIN_name" value="${search_CONTAIN_name[0]}"/>
                </div>
                <button class="btn btn-default btn-sm" type="submit"><s:message code="search"/></button>
            </form>
            <shiro:hasPermission name="core:site:import">
            <div class="form-group">
                <span class="btn btn-success fileinput-button">
                    <i class="glyphicon glyphicon-plus"></i>
                    <span><s:message code="site.import"/></span>
                    <input id="siteFileUpload" type="file" name="file">
                </span>
                <script>
                    var siteJfUpload = Cms.jfUpload("site", {
                        url: "import.do?_site=" + ($.cookie("_site") || ""),
                        file_size_limit: 0,
                        acceptFileTypes: /\.zip$/i,
                        dataType: "html",
                        afterAlways: function (e, data) {
                            setTimeout(function () {
                                location.href = location.href;
                            }, 1000);
                        }
                    });
                </script>
            </div>
            </shiro:hasPermission>
            <form method="post">
                <tags:search_params/>
                <div class="btn-toolbar ls-btn-bar">
                    <div class="btn-group">
                        <shiro:hasPermission name="core:site:create">
                            <button class="btn btn-default" type="button" onclick="location.href='create.do?${searchstring}';"><s:message code="create"/></button>
                        </shiro:hasPermission>
                    </div>
                    <div class="btn-group">
                        <shiro:hasPermission name="core:site:copy">
                            <button class="btn btn-default" type="button" onclick="return optSingle('#copy_opt_');"><s:message code="copy"/></button>
                        </shiro:hasPermission>
                        <shiro:hasPermission name="core:site:edit">
                            <button class="btn btn-default" type="button" onclick="return optSingle('#edit_opt_');"><s:message code="edit"/></button>
                        </shiro:hasPermission>
                    </div>
                    <div class="btn-group">
                        <shiro:hasPermission name="core:site:delete">
                            <button class="btn btn-default" type="button" onclick="return optDelete(this.form);"><s:message code="delete"/></button>
                        </shiro:hasPermission>
                    </div>
                </div>
                <table id="pagedTable" class="table table-condensed table-bordered table-hover ls-tb form-inline">
                    <thead id="sortHead" pagesort="<c:out value='${page_sort[0]}' />" pagedir="${page_sort_dir[0]}" pageurl="list.do?page_sort={0}&page_sort_dir={1}&${searchstringnosort}">
                    <tr class="ls_table_th">
                        <th width="25"><input type="checkbox" onclick="Cms.check('ids',this.checked);"/></th>
                        <th width="160"><s:message code="operate"/></th>
                        <th width="30" class="ls-th-sort"><span class="ls-sort" pagesort="id">ID</span></th>
                        <th class="ls-th-sort"><span class="ls-sort" pagesort="name"><s:message code="site.name"/></span></th>
                        <th class="ls-th-sort"><span class="ls-sort" pagesort="number"><s:message code="site.number"/></span></th>
                        <th class="ls-th-sort"><span class="ls-sort" pagesort="domain"><s:message code="site.domain"/></span></th>
                        <th class="ls-th-sort"><span class="ls-sort" pagesort="org.treeNumber"><s:message code="site.org"/></span></th>
                        <%--<th class="ls-th-sort"><span class="ls-sort" pagesort="status"><s:message code="site.status"/></span></th>--%>
                    </tr>
                    </thead>
                    <tbody>
                    <c:forEach var="bean" varStatus="status" items="${list}">
                        <tr<shiro:hasPermission name="core:site:edit"> ondblclick="location.href=$('#edit_opt_${bean.id}').attr('href');"</shiro:hasPermission>>
                            <td><input type="checkbox" name="ids" value="${bean.id}"/></td>
                            <td align="center">
                                <shiro:hasPermission name="core:site:copy">
                                    <a id="copy_opt_${bean.id}" href="create.do?id=${bean.id}&${searchstring}" class="ls-opt"><s:message code="copy"/></a>
                                </shiro:hasPermission>
                                <shiro:hasPermission name="core:site:edit">
                                    <a id="edit_opt_${bean.id}" href="edit.do?id=${bean.id}&position=${status.index}&${searchstring}" class="ls-opt"><s:message code="edit"/></a>
                                </shiro:hasPermission>
                                <shiro:hasPermission name="core:site:export">
                                    <a id="export_opt_${bean.id}" href="export.do?id=${bean.id}&position=${status.index}&${searchstring}" class="ls-opt"><s:message code="export"/></a>
                                </shiro:hasPermission>
                                <shiro:hasPermission name="core:site:delete">
                                    <c:choose>
                                        <c:when test="${bean.id==1}">
                                            <a class="ls-opt-disabled"><s:message code="delete"/></a>
                                        </c:when>
                                        <c:otherwise>
                                            <a href="delete.do?ids=${bean.id}&${searchstring}" onclick="return confirmDelete();" class="ls-opt"><s:message code="delete"/></a>
                                        </c:otherwise>
                                    </c:choose>
                                </shiro:hasPermission>
                            </td>
                            <td><c:out value="${bean.id}"/></td>
                            <td><span style="padding-left:${bean.treeLevel*12}px"><c:out value="${bean.name}"/></span></td>
                            <td><c:out value="${bean.number}"/></td>
                            <td><c:out value="${bean.domain}"/></td>
                            <td><c:out value="${bean.org.displayName}"/></td>
                                <%--<td><s:message code="site.status.${bean.status}"/></td>--%>
                        </tr>
                    </c:forEach>
                    </tbody>
                </table>
                <c:if test="${fn:length(list) le 0}">
                    <div class="ls-norecord"><s:message code="recordNotFound"/></div>
                </c:if>
            </form>
        </div>
    </div>
</div>
</body>
</html>