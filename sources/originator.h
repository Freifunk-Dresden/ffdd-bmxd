/* Copyright (C) 2006 B.A.T.M.A.N. contributors:
 * Simon Wunderlich, Marek Lindner, Axel Neumann
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of version 2 of the GNU General Public
 * License as published by the Free Software Foundation.
 *
 * This program is distributed in the hope that it will be useful, but
 * WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
 * General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
 * 02110-1301, USA
 *
 */

#define WA_SCALE_FACTOR 1000 /* scale factor used to increase precision of integer division */
#define PROBE_TO100 1
#define PROBE_RANGE 100   // never exceed 255 (uint8_t)

#define MIN_SEQNO 0
#define DEF_SEQNO 0 /* causes seqno to be randomized */
#define MAX_SEQNO ((uint16_t)-1)

#define MAX_PWS 250 /* TBD: should not be larger until ogm->ws and neigh_node.packet_count (and related variables) is only 8 bit */
#define MIN_PWS 10
#define DEF_PWS 100 /* NBRF: NeighBor Ranking sequence Frame) sliding packet range of received orginator messages in squence numbers (should be a multiple of our word size) */
#define ARG_PWS "path_window_size"
extern int32_t my_pws; // my path window size used to quantify the end to end path quality between me and other nodes

#define DEF_LWS 20
#define MAX_LWS 250
#define MIN_LWS 1
#define ARG_LWS "link_window_size"
extern int32_t local_lws; // my link window size used to quantify the link qualities to direct neighbors

// the default link_lounge_size of 2 is good to compensate for ogi ~ but <= aggreg_interval
#define MIN_RTQ_LOUNGE 0
#define MAX_RTQ_LOUNGE 10
#define DEF_RTQ_LOUNGE 2
#define ARG_RTQ_LOUNGE "link_lounge_size"
extern int32_t local_rtq_lounge;

#define RQ_LINK_LOUNGE 0 /* may also be rtq_link_lounge */

#define MIN_PATH_LOUNGE 0
#define MAX_PATH_LOUNGE (SQN_LOUNGE_SIZE - 1)
#define DEF_PATH_LOUNGE 8
#define ARG_PATH_LOUNGE "path_lounge_size"
extern int32_t my_path_lounge;

#define MIN_PATH_HYST 0
#define MAX_PATH_HYST (PROBE_RANGE / PROBE_TO100) / 2
#define DEF_PATH_HYST 0
#define ARG_PATH_HYST "path_hysteresis"

#define MIN_RCNT_HYST 0
#define MAX_RCNT_HYST (PROBE_RANGE / PROBE_TO100) / 2
#define DEF_RCNT_HYST 1
#define ARG_RCNT_HYST "fast_path_hysteresis"

#define DEF_RCNT_PWS 20
#define MIN_RCNT_PWS 2
#define MAX_RCNT_PWS MAX_PWS
#define ARG_RCNT_PWS "fast_path_window_size"

#define DEF_RCNT_LOUNGE DEF_PATH_LOUNGE
#define MIN_RCNT_LOUNGE MIN_PATH_LOUNGE
#define MAX_RCNT_LOUNGE MAX_PATH_LOUNGE
#define ARG_RCNT_LOUNGE "fast_path_lounge_size"

#define DEF_RCNT_FK 150
#define MIN_RCNT_FK 100
#define MAX_RCNT_FK 1000
#define ARG_RCNT_FK "fast_path_faktor"

#define MIN_LATE_PENAL 0
#define MAX_LATE_PENAL PROBE_RANGE // see my_late_penalty probe calulation (uint8_t)
#define DEF_LATE_PENAL 1
#define ARG_LATE_PENAL "lateness_penalty"

#define MIN_DROP_2HLOOP NO
#define MAX_DROP_2HLOOP YES
#define DEF_DROP_2HLOOP NO
#define ARG_DROP_2HLOOP "drop_two_hop_loops"

#define DEF_PURGE_TO 35		//in s;  for ogm_interval of 5000ms = 7 OGM. when server has 10s, then 3OGM
#define MIN_PURGE_TO 10
#define MAX_PURGE_TO 864000 /*10 days*/
#define ARG_PURGE_TO "purge_timeout"
// extern int32_t purge_to;

#define DEF_DAD_TO 100
#define MIN_DAD_TO 1
#define MAX_DAD_TO 3600
#define ARG_DAD_TO "dad_timeout"
extern int32_t dad_to;

#define MIN_ASOCIAL NO
#define MAX_ASOCIAL YES
#define DEF_ASOCIAL NO

#define DEF_TTL 50 /* Time To Live of OGM broadcast messages */
#define MAX_TTL 63
#define MIN_TTL 1
extern int32_t Ttl;

#define DEF_WL_CLONES 100
#define MIN_WL_CLONES 0
#define MAX_WL_CLONES 400
#define ARG_WL_CLONES "wireless_ogm_clone"
extern int32_t wl_clones;

#define DEF_LAN_CLONES 100

#define DEF_ASYM_WEIGHT 100
#define MIN_ASYM_WEIGHT 0
#define MAX_ASYM_WEIGHT 100
#define ARG_ASYM_WEIGHT "asymmetric_weight"

#define DEF_HOP_PENALTY 1
#define MIN_HOP_PENALTY 0
#define MAX_HOP_PENALTY 100
#define ARG_HOP_PENALTY "hop_penalty"

#define DEF_ASYM_EXP 1
#define MIN_ASYM_EXP 0
#define MAX_ASYM_EXP 3
#define ARG_ASYM_EXP "asymmetric_exp"

//SE: add network
#define ARG_NETW "network"
#define MIN_NETW_MASK 8
#define MAX_NETW_MASK 24
#define DEF_NETW_PREFIX "10.0.0.0"
#define DEF_NETW_MASK   8					// primary ip and non-primary

//SE: network filter
// MUST BE default 0. So if user does not pass the network parameter, no OGM will be dropped
extern uint32_t gNetworkPrefix;
extern uint32_t gNetworkNetmask;


//SE: added to separate networks. (network extension could be used, but
//this would cause to increase size of every packet)
#define ARG_NETWORK_ID "netid"
#define MIN_NETWORK_ID 0
#define MAX_NETWORK_ID 65535
#define DEF_NETWORK_ID 0
extern int32_t gNetworkId;	//only 16bits are used, but parameter needs to be 32bit

extern struct batman_if *primary_if;
extern uint32_t primary_addr;

// orig_avl holds all orig_node (own and for all neigh)
extern struct avl_tree orig_avl;

extern LIST_ENTRY if_list;

extern LIST_ENTRY link_list;
extern struct avl_tree link_avl;

// search orig_avl for key "addr". if not present, then a new orig_node object
// is created and added.
struct orig_node *find_or_create_orig_node_in_avl(uint32_t addr);

int tq_rate(struct orig_node *orig_node_neigh, struct batman_if *iif, int range);

void purge_orig(batman_time_t curr_time, struct batman_if *bif);

struct link_node_dev *get_lndev(struct link_node *ln, struct batman_if *bif, uint8_t create);

void process_ogm(struct msg_buff *mb);
void init_originator(void);
void cleanup_originator(void);
