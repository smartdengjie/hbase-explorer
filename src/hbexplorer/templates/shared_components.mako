<%!
from django.template.defaultfilters import urlencode, escape
%>

<%def name="header(title='HBase Explorer', toolbar=True, search_entry=False)">
  <!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01//EN">
  <html>
    <head>
      <title>${title}</title>
    </head>
    <body>
      % if toolbar:
      <div class="toolbar">
        <a href="${url('hbexplorer.views.list_clusters')}"><img src="/hbexplorer/static/art/hbexplorer.png" class="hbexplorer_icon"/></a>
        <div class="hbexplorer-tb-actions ccs-button_bar">
          % if search_entry:
          <input type="text" class="hbexplorer-search-entry headlamp_name_filter ccs-hidden"
            data-filters="OverText, ArtInput"
            data-art-input-type="search" title="Filter by Address"
            data-filter-elements="a.hbexplorer_link_entry" data-filter-parents="tr"/>
          % endif
        </div>
      </div>
      % endif
</%def>

<%def name="footer()">
    </body>
  </html>
</%def>

<%def name="render_field(field, hidden=False, notitle=False)">
<%
  cls = ""
  if hidden: 
    cls = "ccs-hidden"
  titlecls = ""
  if notitle or hidden:
    titlecls = "ccs-hidden"
%>
  <dt class="${titlecls}">${field.label_tag() | n}</dt>
  <dd class="${cls}">${str(field) | n}</dd>
  % if len(field.errors):
    <dt>&nbsp;</dt>
    <dd class="ccs-error validation-advice">
       ${str(field.errors) | n}
     </dd>
  % endif
</%def>

<%def name="render_json(json, indent=0, increment=15)">
  % if type(json) in (list, tuple):
    % for item in json:
      ${render_json(item, indent + increment, increment)}
    % endfor
  % elif type(json) is dict:
    <ul class="indent_${indent}">
    % for key, value in json.iteritems():
      <li>${key}: ${render_json(value)}</li>
    % endfor
    </ul>
  % else:
    ${json}
  % endif
</%def>

<%def name="render_nodes(nodeslist)">
  % for nodes in nodeslist:
    % if nodes:
      % for name, node in nodes.iteritems(): 
  <h3>Name: ${node["name"]}</h3>
  <p>
  <table class="ccs-data_table sortable" cellpadding="0" cellspacing="0">
  <tr><td width="150">Start Code:</td><td>${node["startCode"]}</td></tr>
  <tr><td>Max Heap Size:</td><td>${node["maxHeapSizeMB"]} MB</td></tr>
  <tr><td>Requests:</td><td>${node["requests"]}</td></tr>
  </table>
  </p>
  <u>Regions</u>
        % for region in node["Region"]:
  <p>
  <table class="ccs-data_table sortable" cellpadding="0" cellspacing="0">
  <tr><td width="150">Name:</td><td>${region["name"]}</td></tr>
  <tr><td>Memstore Size:</td><td>${region["memstoreSizeMB"]} MB</td></tr>
  <tr><td>Stores:</td><td>${region["stores"]}</td></tr>
  <tr><td>Store Files:</td><td>${region["storefiles"]}</td></tr>
  <tr><td>Store File Size:</td><td>${region["storefileSizeMB"]} MB</td></tr>
  <tr><td>Store File Index Size:</td><td>${region["storefileIndexSizeMB"]}</td></tr>
  </table>
  </p>
        % endfor
      % endfor
    % else:
    <p>None</p>
    % endif
  % endfor
</%def>
