var y y_s R pie dq pie_s de A y_obs pie_obs R_obs;
varexo e_R e_q e_ys e_pies e_A;

parameters psi1 psi2 psi3 rho_R tau alpha rr k rho_q rho_A rho_ys rho_pies;

psi1 = 1.54;
psi2 = 0.25;
psi3 = 0.25;
rho_R = 0.5;
alpha = 0.3;
rr = 2.51;
k = 0.5;
tau = 0.5;
rho_q = 0.4;
rho_A = 0.2;
rho_ys = 0.9;
rho_pies = 0.7;


model(linear);
y = y(+1) - (tau +alpha*(2-alpha)*(1-tau))*(R-pie(+1))-alpha*(tau +alpha*(2-alpha)*(1-tau))*dq(+1) + alpha*(2-alpha)*((1-tau)/tau)*(y_s-y_s(+1))-A(+1);
pie = exp(-rr/400)*pie(+1)+alpha*exp(-rr/400)*dq(+1)-alpha*dq+(k/(tau+alpha*(2-alpha)*(1-tau)))*y+alpha*(2-alpha)*(1-tau)/(tau*(tau+alpha*(2-alpha)*(1-tau)))*y_s;
pie = de+(1-alpha)*dq+pie_s;
R = rho_R*R(-1)+(1-rho_R)*(psi1*pie+psi2*(y+alpha*(2-alpha)*((1-tau)/tau)*y_s)+psi3*de)+e_R;
dq = rho_q*dq(-1)+e_q;
y_s = rho_ys*y_s(-1)+e_ys;
pie_s = rho_pies*pie_s(-1)+e_pies;
A = rho_A*A(-1)+e_A;
y_obs = y-y(-1)+A;
pie_obs = 4*pie;
R_obs = 4*R;
end;

shocks;
var e_R = 1.25^2;
var e_q = 2.5^2;
var e_A = 1.89;
var e_ys = 1.89;
var e_pies = 1.89;
end;

varobs y_obs R_obs pie_obs dq de;

estimated_params;
psi1 , gamma_pdf,1.5,0.5;
psi2 , gamma_pdf,0.25,0.125;
psi3 , gamma_pdf,0.25,0.125;
rho_R ,beta_pdf,0.5,0.2;
alpha ,beta_pdf,0.3,0.1;
rr ,gamma_pdf,2.5,1;
k , gamma_pdf,0.5,0.25;
tau ,gamma_pdf,0.5,0.2;
rho_q ,beta_pdf,0.4,0.2;
rho_A ,beta_pdf,0.5,0.2;
rho_ys ,beta_pdf,0.8,0.1;
rho_pies,beta_pdf,0.7,0.15;
stderr e_R,inv_gamma_pdf,1.2533,0.6551;
stderr e_q,inv_gamma_pdf,2.5066,1.3103;
stderr e_A,inv_gamma_pdf,1.2533,0.6551;
stderr e_ys,inv_gamma_pdf,1.2533,0.6551;
stderr e_pies,inv_gamma_pdf,1.88,0.9827;
end;

// common syntax for win and unix, for local parallel runs (assuming quad-core):
// all empty fields, except Local and NumCPU
options_.parallel=struct('Local', 1, 'PcName','','NumCPU', [0:3], 'user','','passwd','','RemoteDrive', '', 'RemoteFolder','');


// windows syntax for remote runs (Local=0):
// win passwd has to be typed explicitly!
// RemoteDrive has to be yped explicitly!
// for user, ALSO the group has to be specified, like ISIS\rattoma, i.e. user rattoma in group ISIS
// PcName is the name of the computed in the windows network, i.e. the output of hostname, or the full IP adress
//options_.parallel=struct('Local', 0, 'PcName','iazz9000','NumCPU', [4:6], 'user','ISIS\rattoma','passwd','****', 'RemoteDrive', 'C', 'RemoteFolder','dynare_calcs\Remote');

// example to use several remote PC's to build a grid on windows:
//options_.parallel=struct('Local', 0, 'PcName','iazz9000','NumCPU', [0:3], 'user','ISIS\azziniv','passwd','****', 'RemoteDrive', 'C', 'RemoteFolder','dynare_calcs\Remote');
//options_.parallel(2)=struct('Local', 0, 'PcName','paperino','NumCPU', [0:3], 'user','ISIS\azziniv','passwd','****', 'RemoteDrive', 'D', 'RemoteFolder','dynare_calcs\Remote');
//options_.parallel(3)=struct('Local', 0, 'PcName','didietro','NumCPU', [0:3], 'user','','passwd','','RemoteDrive', ppp(1), 'RemoteFolder',ppp(4:end));
//options_.parallel(4)=struct('Local', 0, 'PcName','uasalap29','NumCPU', [0:1], 'user','ISIS\rattoma','passwd','****', 'RemoteDrive', 'C', 'RemoteFolder','dynare_calcs\Remote');
//options_.parallel(5)=struct('Local', 0, 'PcName','brigitta','NumCPU', [0:3], 'user','ISIS\azziniv','passwd','****', 'RemoteDrive', 'C', 'RemoteFolder','dynare_calcs\Remote');

// unix syntax for remote runs (Local=0):
// no passwd and RemoteDrive needed!
// PcName: full IP address or address
//options_.parallel=struct('Local', 0, 'PcName','paperino.jrc.it','NumCPU', [0:3], 'user','rattoma','passwd','', 'RemoteDrive', '', 'RemoteFolder','/home/rattoma/Remote');

// example to combine local and remote runs (on unix):
//options_.parallel=struct('Local', 1, 'PcName','','NumCPU', [0:3], 'user','','passwd','','RemoteDrive', '', 'RemoteFolder','');
//options_.parallel(2)=struct('Local', 0, 'PcName','paperino.jrc.it','NumCPU', [0:3], 'user','rattoma','passwd','', 'RemoteDrive', '', 'RemoteFolder','/home/rattoma/Remote');

// example to combine local and remote runs (on win):
//options_.parallel=struct('Local', 1, 'PcName','','NumCPU', [0:3], 'user','','passwd','','RemoteDrive', '', 'RemoteFolder','');
//options_.parallel(2)=struct('Local', 0, 'PcName','uasalap29','NumCPU', [0:1], 'user','ISIS\rattoma','passwd','****', 'RemoteDrive', 'C', 'RemoteFolder','dynare_calcs\Remote');

estimation(datafile=data_ca1,first_obs=8,nobs=79,mode_compute=0, mode_file=ls2003_mode, mh_nblocks=4,prefilter=1,mh_jscale=0.5,mh_replic=2000);//, load_mh_file);

