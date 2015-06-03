package it.infn.ct;
/**************************************************************************
Copyright (c) 2011:
Istituto Nazionale di Fisica Nucleare (INFN), Italy
Consorzio COMETA (COMETA), Italy

See http://www.infn.it and and http://www.consorzio-cometa.it for details on the
copyright holders.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
****************************************************************************/
import com.liferay.portal.kernel.exception.PortalException;
import com.liferay.portal.kernel.exception.SystemException;
import com.liferay.portal.model.Company;
import com.liferay.portal.model.PortletPreferences;
import com.liferay.portal.model.User;
import com.liferay.portal.service.UserServiceUtil;
import com.liferay.portal.util.PortalUtil;
import it.infn.ct.GridEngine.UsersTracking.UsersTrackingDBInterface;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.portlet.GenericPortlet;
import javax.portlet.ActionRequest;
import javax.portlet.RenderRequest;
import javax.portlet.ActionResponse;
import javax.portlet.RenderResponse;
import javax.portlet.PortletException;
import java.io.IOException;
import java.util.Vector;
import javax.portlet.PortletRequestDispatcher;

/**
 * map Portlet Class
 */
public class AllJobsMap extends GenericPortlet {

    public void processAction(ActionRequest request, ActionResponse response) throws PortletException,IOException {

    }

    public void doView(RenderRequest request,RenderResponse response) throws PortletException,IOException {

        try {
            response.setContentType("text/html");
            UsersTrackingDBInterface DBInterface = new UsersTrackingDBInterface();
            Company company = PortalUtil.getCompany(request);
            request.setAttribute("TotalUser", DBInterface.getTotalNumberOfUsersWithRunningJobs());
            request.setAttribute("ceList", DBInterface.getCEsGeographicDistributionForAll(company.getName()));
            Vector<String[]> cesListwithCoord = DBInterface.getCEsGeographicDistributionForAll(company.getName());
            System.out.println("#####NOME UTENTE:" + "Company:" + company.getName() );
            if (cesListwithCoord != null) {
            for (int i = 0; i < cesListwithCoord.size(); i++) {
                System.out.println("#######OUT RITA ##### CE = "
                        + cesListwithCoord.elementAt(i)[0] + " Done = "
                        + cesListwithCoord.elementAt(i)[2] + " Runn = "
                        + cesListwithCoord.elementAt(i)[1] + " lat = "
                        + cesListwithCoord.elementAt(i)[4] + " log = "
                        + cesListwithCoord.elementAt(i)[5] + " Mid = "
                        + cesListwithCoord.elementAt(i)[3] + " log = "

                        )
                        ;
            }
            }
        } catch (PortalException ex) {
            Logger.getLogger(AllJobsMap.class.getName()).log(Level.SEVERE, null, ex);
        } catch (SystemException ex) {
            Logger.getLogger(AllJobsMap.class.getName()).log(Level.SEVERE, null, ex);
        }

        response.setContentType("text/html");
        PortletRequestDispatcher dispatcher =
        getPortletContext().getRequestDispatcher("/WEB-INF/jsp/AllJobsMap_view.jsp");
        dispatcher.include(request, response);
    }
}