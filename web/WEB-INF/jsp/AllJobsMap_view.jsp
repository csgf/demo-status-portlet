<%            /**
     * ************************************************************************
     * Copyright (c) 2011: Istituto Nazionale di Fisica Nucleare (INFN), Italy
     * Consorzio COMETA (COMETA), Italy
     *
     * See http://www.infn.it and and http://www.consorzio-cometa.it for details
     * on the copyright holders.
     *
     * Licensed under the Apache License, Version 2.0 (the "License"); you may
     * not use this file except in compliance with the License. You may obtain a
     * copy of the License at
     *
     * http://www.apache.org/licenses/LICENSE-2.0
     *
     * Unless required by applicable law or agreed to in writing, software
     * distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
     * WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
     * License for the specific language governing permissions and limitations
     * under the License.
     * **************************************************************************
     */
    /**
     *
     *
     * @author s.monforte - r.ricceri
     */

%>
<%@page import="com.liferay.portal.service.UserServiceUtil"%>
<%@page import="java.util.Vector"%>
<%@page import="com.liferay.portal.model.User"%>
<%@page import="java.net.URLDecoder"%>
<%@page import="com.liferay.portal.kernel.util.ParamUtil"%>
<%@page import="javax.portlet.*"%>
<%@page contentType="text/html; charset=UTF-8" %>
<%@taglib uri="http://java.sun.com/jstl/core_rt" prefix="c"%>
<%@taglib uri="http://java.sun.com/portlet_2_0" prefix="portlet"%>
<%@taglib uri="http://liferay.com/tld/ui" prefix="liferay-ui"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>
<%@taglib prefix="liferay-ui" uri="http://liferay.com/tld/ui" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<style type="text/css">

    #map-container {
        padding: 6px;
        border-width: 1px;
        border-style: solid;
        border-color: #ccc #ccc #999 #ccc;
        -webkit-box-shadow: rgba(64, 64, 64, 0.5) 0 2px 5px;
        -moz-box-shadow: rgba(64, 64, 64, 0.5) 0 2px 5px;
        box-shadow: rgba(64, 64, 64, 0.1) 0 2px 5px;
        width: 650px;
        height:500px;
    }

    #map {
        width: 650px;
        height:400px;

    }

</style>
<portlet:defineObjects />
<%           Vector<String[]> vecStrArrjList = (Vector<String[]>) request.getAttribute("ceList");
    int TUser = ((Integer) request.getAttribute("TotalUser")).intValue();

%>
<div id="map-container">


    <script type="text/javascript">
        var latlng2markers = [];
        var icons = [];

        icons["plus"] = new google.maps.MarkerImage(
        '<%= renderRequest.getContextPath()%>/flags/plus_new.png',
        new google.maps.Size(16,16),
        new google.maps.Point(0,0),
        new google.maps.Point(8,8)
    );
        icons["minus"] = new google.maps.MarkerImage(
        '<%= renderRequest.getContextPath()%>/flags/minus_new.png',
        new google.maps.Size(16,16),
        new google.maps.Point(0,0),
        new google.maps.Point(8,8)
    
    );

        icons["ce_EMI-gLite"] = new google.maps.MarkerImage(
        '<%= renderRequest.getContextPath()%>/flags/ce-EMI-gLite.png',
        new google.maps.Size(16,16),
        new google.maps.Point(0,0),
        new google.maps.Point(8,8)
    );
        icons["ce_EMI-UNICORE"] = new google.maps.MarkerImage(
        '<%= renderRequest.getContextPath()%>/flags/ce-EMI-Unicore.png',
        new google.maps.Size(16,16),
        new google.maps.Point(0,0),
        new google.maps.Point(8,8)
    );
        icons["ce_GARUDA"] = new google.maps.MarkerImage(
        '<%= renderRequest.getContextPath()%>/flags/ce-GARUDA.png',
        new google.maps.Size(16,16),
        new google.maps.Point(0,0),
        new google.maps.Point(8,8)
    );
        icons["ce_OurGrid"] = new google.maps.MarkerImage(
        '<%= renderRequest.getContextPath()%>/flags/ce-OurGrid.png',
        new google.maps.Size(16,16),
        new google.maps.Point(0,0),
        new google.maps.Point(8,8)
    );

        icons["ce_Genesis-II"] = new google.maps.MarkerImage(
        '<%= renderRequest.getContextPath()%>/flags/ce-Genesis-II.png',
        new google.maps.Size(16,16),
        new google.maps.Point(0,0),
        new google.maps.Point(8,8)
    );
        icons["ce_GOS"] = new google.maps.MarkerImage(
        '<%= renderRequest.getContextPath()%>/flags/ce-gos.png',
        new google.maps.Size(16,16),
        new google.maps.Point(0,0),
        new google.maps.Point(8,8)
    );
        icons["ce_LSF"] = new google.maps.MarkerImage(
        '<%= renderRequest.getContextPath()%>/flags/LSF.png',
        new google.maps.Size(16,16),
        new google.maps.Point(0,0),
        new google.maps.Point(8,8)
    );
        icons["ce_ OCCI Cloud"] = new google.maps.MarkerImage(
        '<%= renderRequest.getContextPath()%>/flags/occi.png',
        new google.maps.Size(16,16),
        new google.maps.Point(0,0),
        new google.maps.Point(8,8)
    );
        function hideMarkers(markersMap,map) {
            for( var k in markersMap) {
                if (markersMap[k].markers.length >1) {
                    var n = markersMap[k].markers.length;
                    var centerMark = new google.maps.Marker({
                        title: "Coordinates:" + markersMap[k].markers[0].getPosition().toString(),
                        position: markersMap[k].markers[0].getPosition(),
                        icon: icons["plus"]
                    });
                    for ( var i=0 ; i<n ; i++ ) {
                        markersMap[k].markers[i].setVisible(false);
                    }
                    centerMark.setMap(map);
                    google.maps.event.addListener(centerMark, 'click', function() {
                        var markersMap = latlng2markers;
                        var k = this.getPosition().toString();
                        var visibility = markersMap[k].markers[0].getVisible();
                        if (visibility == false ) {
                            splitMarkersOnCircle(markersMap[k].markers,
                            markersMap[k].connectors,
                            this.getPosition(),
                            map
                        );
                            this.setIcon(icons["minus"]);
                        }
                        else {
                            var n = markersMap[k].markers.length;
                            for ( var i=0 ; i<n ; i++ ) {
                                markersMap[k].markers[i].setVisible(false);
                                markersMap[k].connectors[i].setMap(null);
                            }
                            markersMap[k].connectors = [];
                            this.setIcon(icons["plus"]);
                        }
                    });

                }
            }
        }

        function splitMarkersOnCircle(markers, connectors, center, map) {
            var z = 1+(map.getZoom() % 4);
            var r = 64.0 /  (z*Math.exp(z/2));
            var n = markers.length;
            var dtheta = 2.0*Math.PI / n
            var theta = 0;
            for ( var i=0 ; i<n ; i++ ) {
                var X = center.lat() + r*Math.cos(theta);
                var Y = center.lng() + r*Math.sin(theta);
                markers[i].setPosition(new google.maps.LatLng(X,Y));
                markers[i].setVisible(true);
                theta += dtheta;
                var line = new google.maps.Polyline({
                    path: [center,new google.maps.LatLng(X,Y)],
                    clickable: false,
                    strokeColor: "#0000ff",
                    strokeOpacity: 1,
                    strokeWeight: 2
                });
                line.setMap(map);
                connectors.push(line);

            }
        }

        function initialize() {

            var map = new google.maps.Map(document.getElementById('map'), {
                zoom:1,
                center: new google.maps.LatLng(25,10),
                mapTypeId: google.maps.MapTypeId.ROADMAP
            });
            var infoWindow   = new google.maps.InfoWindow();
            var markers = [];
            var marker =null;
        <%
            int RunSum = 0;
            int DoneSum = 0;
            int sumGridRun = 0;
            int sumGridDone = 0;
            int sumLSFDone = 0;
            int sumLSFRun = 0;
            int sumOcciRun = 0;
            int sumOcciDone = 0;
            int sumUNICORERun = 0;
            int sumUNICOREDone=0;



            for (int i = 0; i < vecStrArrjList.size(); i++) {
                if (vecStrArrjList.elementAt(i)[3].equals("0") || vecStrArrjList.elementAt(i)[3].equals("2") || vecStrArrjList.elementAt(i)[3].equals("3") || vecStrArrjList.elementAt(i)[3].equals("4") || vecStrArrjList.elementAt(i)[3].equals("5")) {
                    sumGridRun += Integer.parseInt(vecStrArrjList.elementAt(i)[1]);
                    sumGridDone += Integer.parseInt(vecStrArrjList.elementAt(i)[2]);
                } else if (vecStrArrjList.elementAt(i)[3].equals("1")) {
                    sumUNICORERun += Integer.parseInt(vecStrArrjList.elementAt(i)[1]);
                    sumUNICOREDone += Integer.parseInt(vecStrArrjList.elementAt(i)[2]);
                } else if (vecStrArrjList.elementAt(i)[3].equals("6")) {
                    sumLSFRun += Integer.parseInt(vecStrArrjList.elementAt(i)[1]);
                    sumLSFDone += Integer.parseInt(vecStrArrjList.elementAt(i)[2]);
                } else if (vecStrArrjList.elementAt(i)[3].equals("7")) {
                    sumOcciRun += Integer.parseInt(vecStrArrjList.elementAt(i)[1]);
                    sumOcciDone += Integer.parseInt(vecStrArrjList.elementAt(i)[2]);
                }

            }

            for (String[] strArrJob : vecStrArrjList) {
                RunSum += Integer.parseInt(strArrJob[1]);
                DoneSum += Integer.parseInt(strArrJob[2]);
                String middleware[] = {"EMI-gLite", "EMI-UNICORE", "GARUDA", "OurGrid", "Genesis-II", "GOS", "LSF", " OCCI Cloud"};
                String mw = middleware[Integer.parseInt(strArrJob[3])];

        %>

                marker = new google.maps.Marker({
                    position: new google.maps.LatLng(<%= strArrJob[4]%>,<%= strArrJob[5]%>),
                    icon:icons["ce_<%=mw%>"],
                    title:'CE:<%= strArrJob[0]%>; N.Jobs running: <%= strArrJob[1]%>; N.Jobs done: <%= strArrJob[2]%>; Middleware: <%= mw%>'
                });
                google.maps.event.addListener(marker, 'click', function() {
                    infoWindow.setContent('<b>CE:</b><%= strArrJob[0]%> <br><b>N.Jobs running:</b> <%= strArrJob[1]%><br><b>N.Jobs done:</b><%= strArrJob[2]%><br><b>Middleware:</b><%= mw%>');
                    infoWindow.open(map, this);
                });
                var latlngKey=marker.position.toString();
                if ( latlng2markers[latlngKey] == null ) {
                    latlng2markers[latlngKey] = {markers:[], connectors:[]};
                }
                marker.setMap(map);
                latlng2markers[latlngKey].markers.push(marker);
                markers.push(marker);
        <%}%>
                hideMarkers(latlng2markers,map);
                //var markerCluster = new MarkerClusterer(map, markers, {maxZoom: 3, gridSize: 20});
            }
            google.maps.event.addDomListener(window, 'load', initialize);
    </script>
    <div>Total number of users submitting jobs: <b><%= TUser%></b><br>
        Total number of running jobs: <b><%= RunSum%></b> of which <b><%= sumGridRun%></b> on Grid, <b><%= sumUNICORERun%></b> on HPC, <b><%= sumOcciRun%></b> on Cloud and <b><%= sumLSFRun%></b> on local resources <br>
        Total number of done jobs: <b><%= DoneSum%></b> of which <b><%= sumGridDone%></b> on Grid, <b><%= sumUNICOREDone%></b> on HPC, <b><%= sumOcciDone%></b> on Cloud and <b><%= sumLSFDone%></b> on local resources <br><hr>
    </div>
    <div id="map"></div>

</div>
