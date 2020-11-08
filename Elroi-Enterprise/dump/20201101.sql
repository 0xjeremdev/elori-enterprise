--
-- PostgreSQL database dump
--

-- Dumped from database version 13.0
-- Dumped by pg_dump version 13.0

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

DROP DATABASE IF EXISTS target_project;
--
-- Name: target_project; Type: DATABASE; Schema: -; Owner: postgres
--

CREATE DATABASE target_project WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE = 'English_United States.1252';


ALTER DATABASE target_project OWNER TO postgres;

\connect target_project

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: accounts_account; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.accounts_account (
    id integer NOT NULL,
    password character varying(128) NOT NULL,
    date_joined timestamp with time zone NOT NULL,
    email character varying(60) NOT NULL,
    username character varying(150) NOT NULL,
    first_name character varying(30) NOT NULL,
    last_name character varying(150) NOT NULL,
    verification_code integer,
    otp_verified boolean NOT NULL,
    is_admin boolean NOT NULL,
    is_active boolean NOT NULL,
    is_verified boolean NOT NULL,
    is_banned boolean NOT NULL,
    is_staff boolean NOT NULL,
    is_superuser boolean NOT NULL,
    last_login timestamp with time zone,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL
);


ALTER TABLE public.accounts_account OWNER TO postgres;

--
-- Name: accounts_account_groups; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.accounts_account_groups (
    id integer NOT NULL,
    account_id integer NOT NULL,
    group_id integer NOT NULL
);


ALTER TABLE public.accounts_account_groups OWNER TO postgres;

--
-- Name: accounts_account_groups_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.accounts_account_groups_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.accounts_account_groups_id_seq OWNER TO postgres;

--
-- Name: accounts_account_groups_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.accounts_account_groups_id_seq OWNED BY public.accounts_account_groups.id;


--
-- Name: accounts_account_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.accounts_account_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.accounts_account_id_seq OWNER TO postgres;

--
-- Name: accounts_account_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.accounts_account_id_seq OWNED BY public.accounts_account.id;


--
-- Name: accounts_account_user_permissions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.accounts_account_user_permissions (
    id integer NOT NULL,
    account_id integer NOT NULL,
    permission_id integer NOT NULL
);


ALTER TABLE public.accounts_account_user_permissions OWNER TO postgres;

--
-- Name: accounts_account_user_permissions_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.accounts_account_user_permissions_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.accounts_account_user_permissions_id_seq OWNER TO postgres;

--
-- Name: accounts_account_user_permissions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.accounts_account_user_permissions_id_seq OWNED BY public.accounts_account_user_permissions.id;


--
-- Name: admin_enterprise_config; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.admin_enterprise_config (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    key character varying(255) NOT NULL,
    value character varying(255) NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    created_by_id integer,
    updated_by_id integer
);


ALTER TABLE public.admin_enterprise_config OWNER TO postgres;

--
-- Name: admin_enterprise_config_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.admin_enterprise_config_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.admin_enterprise_config_id_seq OWNER TO postgres;

--
-- Name: admin_enterprise_config_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.admin_enterprise_config_id_seq OWNED BY public.admin_enterprise_config.id;


--
-- Name: analytics_activitylog; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.analytics_activitylog (
    id integer NOT NULL,
    username_persistent character varying(200),
    requested_at timestamp with time zone NOT NULL,
    response_ms integer NOT NULL,
    path character varying(255) NOT NULL,
    view character varying(255),
    view_method character varying(255),
    remote_addr inet NOT NULL,
    host character varying(200) NOT NULL,
    method character varying(10) NOT NULL,
    query_params text,
    data text,
    response text,
    errors text,
    status_code integer,
    user_id integer,
    elroi_id character varying(9) NOT NULL,
    CONSTRAINT analytics_activitylog_response_ms_check CHECK ((response_ms >= 0)),
    CONSTRAINT analytics_activitylog_status_code_check CHECK ((status_code >= 0))
);


ALTER TABLE public.analytics_activitylog OWNER TO postgres;

--
-- Name: analytics_activitylog_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.analytics_activitylog_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.analytics_activitylog_id_seq OWNER TO postgres;

--
-- Name: analytics_activitylog_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.analytics_activitylog_id_seq OWNED BY public.analytics_activitylog.id;


--
-- Name: analytics_analytics; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.analytics_analytics (
    id integer NOT NULL,
    object_id inet NOT NULL,
    created_at timestamp with time zone NOT NULL,
    content_type_id integer,
    user_id integer NOT NULL
);


ALTER TABLE public.analytics_analytics OWNER TO postgres;

--
-- Name: analytics_analytics_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.analytics_analytics_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.analytics_analytics_id_seq OWNER TO postgres;

--
-- Name: analytics_analytics_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.analytics_analytics_id_seq OWNED BY public.analytics_analytics.id;


--
-- Name: auth_group; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.auth_group (
    id integer NOT NULL,
    name character varying(150) NOT NULL
);


ALTER TABLE public.auth_group OWNER TO postgres;

--
-- Name: auth_group_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.auth_group_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.auth_group_id_seq OWNER TO postgres;

--
-- Name: auth_group_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.auth_group_id_seq OWNED BY public.auth_group.id;


--
-- Name: auth_group_permissions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.auth_group_permissions (
    id integer NOT NULL,
    group_id integer NOT NULL,
    permission_id integer NOT NULL
);


ALTER TABLE public.auth_group_permissions OWNER TO postgres;

--
-- Name: auth_group_permissions_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.auth_group_permissions_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.auth_group_permissions_id_seq OWNER TO postgres;

--
-- Name: auth_group_permissions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.auth_group_permissions_id_seq OWNED BY public.auth_group_permissions.id;


--
-- Name: auth_permission; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.auth_permission (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    content_type_id integer NOT NULL,
    codename character varying(100) NOT NULL
);


ALTER TABLE public.auth_permission OWNER TO postgres;

--
-- Name: auth_permission_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.auth_permission_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.auth_permission_id_seq OWNER TO postgres;

--
-- Name: auth_permission_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.auth_permission_id_seq OWNED BY public.auth_permission.id;


--
-- Name: consumer_requests; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.consumer_requests (
    id integer NOT NULL,
    elroi_id character varying(14),
    title character varying(255),
    request_type integer NOT NULL,
    description text,
    is_data_subject_name boolean NOT NULL,
    status integer NOT NULL,
    process_end_date timestamp with time zone,
    request_date timestamp with time zone,
    approved_date timestamp with time zone,
    extend_requested boolean NOT NULL,
    extend_requested_date timestamp with time zone,
    extend_requested_days integer NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    customer_id integer,
    enterprise_id integer NOT NULL,
    request_form jsonb
);


ALTER TABLE public.consumer_requests OWNER TO postgres;

--
-- Name: consumer_requests_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.consumer_requests_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.consumer_requests_id_seq OWNER TO postgres;

--
-- Name: consumer_requests_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.consumer_requests_id_seq OWNED BY public.consumer_requests.id;


--
-- Name: customer_uploads; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.customer_uploads (
    id integer NOT NULL,
    file character varying(100) NOT NULL,
    name character varying(255) NOT NULL,
    size integer NOT NULL,
    created_at timestamp with time zone NOT NULL,
    customer_id integer
);


ALTER TABLE public.customer_uploads OWNER TO postgres;

--
-- Name: customer_uploads_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.customer_uploads_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.customer_uploads_id_seq OWNER TO postgres;

--
-- Name: customer_uploads_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.customer_uploads_id_seq OWNED BY public.customer_uploads.id;


--
-- Name: customers; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.customers (
    id integer NOT NULL,
    elroi_id character varying(9),
    email character varying(60),
    first_name character varying(40),
    last_name character varying(40),
    state_resident boolean NOT NULL,
    created_at timestamp with time zone NOT NULL,
    user_id integer,
    file character varying(100),
    additional_fields jsonb NOT NULL
);


ALTER TABLE public.customers OWNER TO postgres;

--
-- Name: customers_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.customers_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.customers_id_seq OWNER TO postgres;

--
-- Name: customers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.customers_id_seq OWNED BY public.customers.id;


--
-- Name: django_admin_log; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.django_admin_log (
    id integer NOT NULL,
    action_time timestamp with time zone NOT NULL,
    object_id text,
    object_repr character varying(200) NOT NULL,
    action_flag smallint NOT NULL,
    change_message text NOT NULL,
    content_type_id integer,
    user_id integer NOT NULL,
    CONSTRAINT django_admin_log_action_flag_check CHECK ((action_flag >= 0))
);


ALTER TABLE public.django_admin_log OWNER TO postgres;

--
-- Name: django_admin_log_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.django_admin_log_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.django_admin_log_id_seq OWNER TO postgres;

--
-- Name: django_admin_log_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.django_admin_log_id_seq OWNED BY public.django_admin_log.id;


--
-- Name: django_content_type; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.django_content_type (
    id integer NOT NULL,
    app_label character varying(100) NOT NULL,
    model character varying(100) NOT NULL
);


ALTER TABLE public.django_content_type OWNER TO postgres;

--
-- Name: django_content_type_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.django_content_type_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.django_content_type_id_seq OWNER TO postgres;

--
-- Name: django_content_type_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.django_content_type_id_seq OWNED BY public.django_content_type.id;


--
-- Name: django_migrations; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.django_migrations (
    id integer NOT NULL,
    app character varying(255) NOT NULL,
    name character varying(255) NOT NULL,
    applied timestamp with time zone NOT NULL
);


ALTER TABLE public.django_migrations OWNER TO postgres;

--
-- Name: django_migrations_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.django_migrations_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.django_migrations_id_seq OWNER TO postgres;

--
-- Name: django_migrations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.django_migrations_id_seq OWNED BY public.django_migrations.id;


--
-- Name: django_session; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.django_session (
    session_key character varying(40) NOT NULL,
    session_data text NOT NULL,
    expire_date timestamp with time zone NOT NULL
);


ALTER TABLE public.django_session OWNER TO postgres;

--
-- Name: enterprise_configuration; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.enterprise_configuration (
    id integer NOT NULL,
    title character varying(255) NOT NULL,
    additional_configuration jsonb NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    enterprise_id integer NOT NULL,
    background_image character varying(100) NOT NULL,
    company_name character varying(255) NOT NULL,
    logo character varying(100) NOT NULL,
    resident_state boolean NOT NULL,
    site_color character varying(7) NOT NULL,
    site_theme character varying(12) NOT NULL,
    website_launched_to character varying(255) NOT NULL
);


ALTER TABLE public.enterprise_configuration OWNER TO postgres;

--
-- Name: enterprise_configuration_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.enterprise_configuration_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.enterprise_configuration_id_seq OWNER TO postgres;

--
-- Name: enterprise_configuration_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.enterprise_configuration_id_seq OWNED BY public.enterprise_configuration.id;


--
-- Name: enterprise_customer_configuration; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.enterprise_customer_configuration (
    id integer NOT NULL,
    title character varying(255) NOT NULL,
    config jsonb NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    author_id integer NOT NULL
);


ALTER TABLE public.enterprise_customer_configuration OWNER TO postgres;

--
-- Name: enterprise_customer_configuration_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.enterprise_customer_configuration_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.enterprise_customer_configuration_id_seq OWNER TO postgres;

--
-- Name: enterprise_customer_configuration_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.enterprise_customer_configuration_id_seq OWNED BY public.enterprise_customer_configuration.id;


--
-- Name: enterprises; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.enterprises (
    id integer NOT NULL,
    elroi_id character varying(9),
    name character varying(255),
    web character varying(255),
    trial_start timestamp with time zone,
    trial_end timestamp with time zone,
    current_plan_end timestamp with time zone,
    created_at timestamp with time zone NOT NULL,
    user_id integer,
    email character varying(80) NOT NULL,
    is_active boolean NOT NULL,
    updated_by_id integer,
    allow_api_call boolean NOT NULL,
    allow_email_data boolean NOT NULL,
    payment jsonb,
    turn_off_date timestamp with time zone
);


ALTER TABLE public.enterprises OWNER TO postgres;

--
-- Name: enterprises_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.enterprises_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.enterprises_id_seq OWNER TO postgres;

--
-- Name: enterprises_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.enterprises_id_seq OWNED BY public.enterprises.id;


--
-- Name: otp_static_staticdevice; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.otp_static_staticdevice (
    id integer NOT NULL,
    name character varying(64) NOT NULL,
    confirmed boolean NOT NULL,
    user_id integer NOT NULL,
    throttling_failure_count integer NOT NULL,
    throttling_failure_timestamp timestamp with time zone,
    CONSTRAINT otp_static_staticdevice_throttling_failure_count_check CHECK ((throttling_failure_count >= 0))
);


ALTER TABLE public.otp_static_staticdevice OWNER TO postgres;

--
-- Name: otp_static_staticdevice_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.otp_static_staticdevice_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.otp_static_staticdevice_id_seq OWNER TO postgres;

--
-- Name: otp_static_staticdevice_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.otp_static_staticdevice_id_seq OWNED BY public.otp_static_staticdevice.id;


--
-- Name: otp_static_statictoken; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.otp_static_statictoken (
    id integer NOT NULL,
    token character varying(16) NOT NULL,
    device_id integer NOT NULL
);


ALTER TABLE public.otp_static_statictoken OWNER TO postgres;

--
-- Name: otp_static_statictoken_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.otp_static_statictoken_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.otp_static_statictoken_id_seq OWNER TO postgres;

--
-- Name: otp_static_statictoken_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.otp_static_statictoken_id_seq OWNED BY public.otp_static_statictoken.id;


--
-- Name: otp_totp_totpdevice; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.otp_totp_totpdevice (
    id integer NOT NULL,
    name character varying(64) NOT NULL,
    confirmed boolean NOT NULL,
    key character varying(80) NOT NULL,
    step smallint NOT NULL,
    t0 bigint NOT NULL,
    digits smallint NOT NULL,
    tolerance smallint NOT NULL,
    drift smallint NOT NULL,
    last_t bigint NOT NULL,
    user_id integer NOT NULL,
    throttling_failure_count integer NOT NULL,
    throttling_failure_timestamp timestamp with time zone,
    CONSTRAINT otp_totp_totpdevice_digits_check CHECK ((digits >= 0)),
    CONSTRAINT otp_totp_totpdevice_step_check CHECK ((step >= 0)),
    CONSTRAINT otp_totp_totpdevice_throttling_failure_count_check CHECK ((throttling_failure_count >= 0)),
    CONSTRAINT otp_totp_totpdevice_tolerance_check CHECK ((tolerance >= 0))
);


ALTER TABLE public.otp_totp_totpdevice OWNER TO postgres;

--
-- Name: otp_totp_totpdevice_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.otp_totp_totpdevice_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.otp_totp_totpdevice_id_seq OWNER TO postgres;

--
-- Name: otp_totp_totpdevice_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.otp_totp_totpdevice_id_seq OWNED BY public.otp_totp_totpdevice.id;


--
-- Name: token_blacklist_blacklistedtoken; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.token_blacklist_blacklistedtoken (
    id integer NOT NULL,
    blacklisted_at timestamp with time zone NOT NULL,
    token_id integer NOT NULL
);


ALTER TABLE public.token_blacklist_blacklistedtoken OWNER TO postgres;

--
-- Name: token_blacklist_blacklistedtoken_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.token_blacklist_blacklistedtoken_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.token_blacklist_blacklistedtoken_id_seq OWNER TO postgres;

--
-- Name: token_blacklist_blacklistedtoken_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.token_blacklist_blacklistedtoken_id_seq OWNED BY public.token_blacklist_blacklistedtoken.id;


--
-- Name: token_blacklist_outstandingtoken; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.token_blacklist_outstandingtoken (
    id integer NOT NULL,
    token text NOT NULL,
    created_at timestamp with time zone,
    expires_at timestamp with time zone NOT NULL,
    user_id integer,
    jti character varying(255) NOT NULL
);


ALTER TABLE public.token_blacklist_outstandingtoken OWNER TO postgres;

--
-- Name: token_blacklist_outstandingtoken_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.token_blacklist_outstandingtoken_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.token_blacklist_outstandingtoken_id_seq OWNER TO postgres;

--
-- Name: token_blacklist_outstandingtoken_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.token_blacklist_outstandingtoken_id_seq OWNED BY public.token_blacklist_outstandingtoken.id;


--
-- Name: user_guide; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.user_guide (
    id integer NOT NULL,
    title character varying(255),
    content text NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    owner_id integer NOT NULL
);


ALTER TABLE public.user_guide OWNER TO postgres;

--
-- Name: user_guide_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.user_guide_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.user_guide_id_seq OWNER TO postgres;

--
-- Name: user_guide_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.user_guide_id_seq OWNED BY public.user_guide.id;


--
-- Name: user_guide_uploads; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.user_guide_uploads (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    file character varying(100) NOT NULL,
    size integer NOT NULL,
    created_at timestamp with time zone NOT NULL,
    user_guide_id integer NOT NULL
);


ALTER TABLE public.user_guide_uploads OWNER TO postgres;

--
-- Name: user_guide_uploads_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.user_guide_uploads_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.user_guide_uploads_id_seq OWNER TO postgres;

--
-- Name: user_guide_uploads_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.user_guide_uploads_id_seq OWNED BY public.user_guide_uploads.id;


--
-- Name: accounts_account id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.accounts_account ALTER COLUMN id SET DEFAULT nextval('public.accounts_account_id_seq'::regclass);


--
-- Name: accounts_account_groups id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.accounts_account_groups ALTER COLUMN id SET DEFAULT nextval('public.accounts_account_groups_id_seq'::regclass);


--
-- Name: accounts_account_user_permissions id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.accounts_account_user_permissions ALTER COLUMN id SET DEFAULT nextval('public.accounts_account_user_permissions_id_seq'::regclass);


--
-- Name: admin_enterprise_config id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.admin_enterprise_config ALTER COLUMN id SET DEFAULT nextval('public.admin_enterprise_config_id_seq'::regclass);


--
-- Name: analytics_activitylog id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.analytics_activitylog ALTER COLUMN id SET DEFAULT nextval('public.analytics_activitylog_id_seq'::regclass);


--
-- Name: analytics_analytics id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.analytics_analytics ALTER COLUMN id SET DEFAULT nextval('public.analytics_analytics_id_seq'::regclass);


--
-- Name: auth_group id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_group ALTER COLUMN id SET DEFAULT nextval('public.auth_group_id_seq'::regclass);


--
-- Name: auth_group_permissions id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_group_permissions ALTER COLUMN id SET DEFAULT nextval('public.auth_group_permissions_id_seq'::regclass);


--
-- Name: auth_permission id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_permission ALTER COLUMN id SET DEFAULT nextval('public.auth_permission_id_seq'::regclass);


--
-- Name: consumer_requests id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.consumer_requests ALTER COLUMN id SET DEFAULT nextval('public.consumer_requests_id_seq'::regclass);


--
-- Name: customer_uploads id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.customer_uploads ALTER COLUMN id SET DEFAULT nextval('public.customer_uploads_id_seq'::regclass);


--
-- Name: customers id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.customers ALTER COLUMN id SET DEFAULT nextval('public.customers_id_seq'::regclass);


--
-- Name: django_admin_log id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.django_admin_log ALTER COLUMN id SET DEFAULT nextval('public.django_admin_log_id_seq'::regclass);


--
-- Name: django_content_type id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.django_content_type ALTER COLUMN id SET DEFAULT nextval('public.django_content_type_id_seq'::regclass);


--
-- Name: django_migrations id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.django_migrations ALTER COLUMN id SET DEFAULT nextval('public.django_migrations_id_seq'::regclass);


--
-- Name: enterprise_configuration id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.enterprise_configuration ALTER COLUMN id SET DEFAULT nextval('public.enterprise_configuration_id_seq'::regclass);


--
-- Name: enterprise_customer_configuration id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.enterprise_customer_configuration ALTER COLUMN id SET DEFAULT nextval('public.enterprise_customer_configuration_id_seq'::regclass);


--
-- Name: enterprises id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.enterprises ALTER COLUMN id SET DEFAULT nextval('public.enterprises_id_seq'::regclass);


--
-- Name: otp_static_staticdevice id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.otp_static_staticdevice ALTER COLUMN id SET DEFAULT nextval('public.otp_static_staticdevice_id_seq'::regclass);


--
-- Name: otp_static_statictoken id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.otp_static_statictoken ALTER COLUMN id SET DEFAULT nextval('public.otp_static_statictoken_id_seq'::regclass);


--
-- Name: otp_totp_totpdevice id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.otp_totp_totpdevice ALTER COLUMN id SET DEFAULT nextval('public.otp_totp_totpdevice_id_seq'::regclass);


--
-- Name: token_blacklist_blacklistedtoken id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.token_blacklist_blacklistedtoken ALTER COLUMN id SET DEFAULT nextval('public.token_blacklist_blacklistedtoken_id_seq'::regclass);


--
-- Name: token_blacklist_outstandingtoken id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.token_blacklist_outstandingtoken ALTER COLUMN id SET DEFAULT nextval('public.token_blacklist_outstandingtoken_id_seq'::regclass);


--
-- Name: user_guide id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_guide ALTER COLUMN id SET DEFAULT nextval('public.user_guide_id_seq'::regclass);


--
-- Name: user_guide_uploads id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_guide_uploads ALTER COLUMN id SET DEFAULT nextval('public.user_guide_uploads_id_seq'::regclass);


--
-- Data for Name: accounts_account; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.accounts_account (id, password, date_joined, email, username, first_name, last_name, verification_code, otp_verified, is_admin, is_active, is_verified, is_banned, is_staff, is_superuser, last_login, created_at, updated_at) VALUES (3, 'pbkdf2_sha256$150000$4S54dtZZhpfF$08wyG5y7AYvvohmjfnA5845cYNz/y+kWLTv/LodKdIw=', '2020-10-21 22:33:29.791853+03', 'dem1o@demo.com', 'dem1o@demo.com', 'Demo', 'Demo', 0, false, false, true, false, false, false, false, '2020-10-21 22:33:29.934559+03', '2020-10-21 22:33:29.92554+03', '2020-10-21 22:33:29.934559+03');
INSERT INTO public.accounts_account (id, password, date_joined, email, username, first_name, last_name, verification_code, otp_verified, is_admin, is_active, is_verified, is_banned, is_staff, is_superuser, last_login, created_at, updated_at) VALUES (4, 'pbkdf2_sha256$150000$F7TOqhPbGUH0$Fq+tJp8NnDur7iw5DVMNjg3w3JnHPOxOrQ+hd0yX2Nc=', '2020-10-21 22:34:55.592015+03', 'demo1@demo.com', 'demo1@demo.com', 'Demo1', 'Demo1', 0, false, false, true, false, false, false, false, '2020-10-21 22:34:55.737625+03', '2020-10-21 22:34:55.733678+03', '2020-10-21 22:34:55.737625+03');
INSERT INTO public.accounts_account (id, password, date_joined, email, username, first_name, last_name, verification_code, otp_verified, is_admin, is_active, is_verified, is_banned, is_staff, is_superuser, last_login, created_at, updated_at) VALUES (5, 'pbkdf2_sha256$150000$sY2Y4aGi0PUp$RnKdrqCmxjO+/DJQhKcDg6B+V89cw3M/W9o0ddEYTdY=', '2020-10-21 22:38:47.910177+03', 'demo2@demo.com', 'demo2@demo.com', 'Demo1', 'Demo1', 0, false, false, true, false, false, false, false, '2020-10-21 22:38:48.046967+03', '2020-10-21 22:38:48.043871+03', '2020-10-21 22:38:48.046967+03');
INSERT INTO public.accounts_account (id, password, date_joined, email, username, first_name, last_name, verification_code, otp_verified, is_admin, is_active, is_verified, is_banned, is_staff, is_superuser, last_login, created_at, updated_at) VALUES (6, 'pbkdf2_sha256$150000$DFSbN0McVLgb$Eh+Tb9SdrW6RJtgRMzbGf3hmv80il3cHnymObzVJh8U=', '2020-10-21 22:40:40.447053+03', 'demo23@demo.com', 'demo23@demo.com', 'Demo3', 'Demo3', 0, false, false, true, false, false, false, false, '2020-10-21 22:40:40.583653+03', '2020-10-21 22:40:40.581657+03', '2020-10-21 22:40:40.583653+03');
INSERT INTO public.accounts_account (id, password, date_joined, email, username, first_name, last_name, verification_code, otp_verified, is_admin, is_active, is_verified, is_banned, is_staff, is_superuser, last_login, created_at, updated_at) VALUES (7, 'pbkdf2_sha256$150000$pT0G1aIUgly7$B3TGWr6dDa8wzNqKRY6KJ1TMUSwMbSqwMHQCwgyQub4=', '2020-10-21 22:42:20.388552+03', 'demo4@demo.com', 'demo4@demo.com', 'Demo4', 'Demo4', 0, false, false, true, false, false, false, false, '2020-10-21 22:42:20.527137+03', '2020-10-21 22:42:20.525142+03', '2020-10-21 22:42:20.527137+03');
INSERT INTO public.accounts_account (id, password, date_joined, email, username, first_name, last_name, verification_code, otp_verified, is_admin, is_active, is_verified, is_banned, is_staff, is_superuser, last_login, created_at, updated_at) VALUES (2, 'pbkdf2_sha256$150000$QozJR5TP81nM$B1rP8EaOVs5eQrEQFguS1t0A4g0Ioe/ZDpG7WbrWxUU=', '2020-10-20 14:46:20.757969+03', 'user@example.com', 'user@example.com', 'Alex', 'Lesan', 0, false, false, true, true, false, false, false, '2020-10-20 14:58:44.910756+03', '2020-10-20 14:46:20.895494+03', '2020-10-20 14:58:44.910756+03');
INSERT INTO public.accounts_account (id, password, date_joined, email, username, first_name, last_name, verification_code, otp_verified, is_admin, is_active, is_verified, is_banned, is_staff, is_superuser, last_login, created_at, updated_at) VALUES (8, 'pbkdf2_sha256$150000$yVH04ZJXVWV8$oAp68WHwhb7rywJ2emtcWAgAJHukqAthYO85lK1hVds=', '2020-10-21 22:44:46.445787+03', 'demo5@demo.com', 'demo5@demo.com', 'Demo5', 'Demo5', 0, false, false, true, false, false, false, false, '2020-10-21 22:44:46.596572+03', '2020-10-21 22:44:46.580426+03', '2020-10-21 22:44:46.596572+03');
INSERT INTO public.accounts_account (id, password, date_joined, email, username, first_name, last_name, verification_code, otp_verified, is_admin, is_active, is_verified, is_banned, is_staff, is_superuser, last_login, created_at, updated_at) VALUES (9, 'pbkdf2_sha256$150000$wNT8MS361Pr7$FXEmgHD3oavbMwYj/CP9kFIkSQAqnCbw6W52OaUXBhk=', '2020-10-21 22:49:30.115965+03', 'demo6@demo.com', 'demo6@demo.com', 'Demo6', 'Demo6', 0, false, false, true, false, false, false, false, '2020-10-21 22:49:30.254594+03', '2020-10-21 22:49:30.2526+03', '2020-10-21 22:49:30.254594+03');
INSERT INTO public.accounts_account (id, password, date_joined, email, username, first_name, last_name, verification_code, otp_verified, is_admin, is_active, is_verified, is_banned, is_staff, is_superuser, last_login, created_at, updated_at) VALUES (10, 'pbkdf2_sha256$150000$kN1HBkT6kspw$08nUvzeh1LjmrLUBRh54C+7nhpN8CRec86ZIUiXx+6A=', '2020-10-24 05:17:02.354673+03', 'test5@demo.com', 'test5@demo.com', 'First_name', 'Last-name', 0, false, false, true, false, false, false, false, '2020-10-24 05:17:02.511253+03', '2020-10-24 05:17:02.500283+03', '2020-10-24 05:17:02.511253+03');
INSERT INTO public.accounts_account (id, password, date_joined, email, username, first_name, last_name, verification_code, otp_verified, is_admin, is_active, is_verified, is_banned, is_staff, is_superuser, last_login, created_at, updated_at) VALUES (11, 'pbkdf2_sha256$150000$PCkzmmhMmgcw$HlIwZZPDxZ7o6YIOheSleYTUu61EIkVb5mPntV7axDo=', '2020-10-26 15:45:41.993489+02', 'test75@demo.com', '', '', '', 0, false, false, true, false, false, false, false, '2020-10-26 15:45:42.140496+02', '2020-10-26 15:45:42.140496+02', '2020-10-26 15:45:42.140496+02');
INSERT INTO public.accounts_account (id, password, date_joined, email, username, first_name, last_name, verification_code, otp_verified, is_admin, is_active, is_verified, is_banned, is_staff, is_superuser, last_login, created_at, updated_at) VALUES (14, 'pbkdf2_sha256$150000$rN0RRDPGGMsI$t/MlpFoMRCHEVB6eK8cb1klAyFNDfX+2Mx/IvbHhX0k=', '2020-10-26 15:56:56.966709+02', 'tes@dewmo.com', 'tes@dewmo.com', '', '', 0, false, false, true, false, false, false, false, '2020-10-26 15:56:57.100352+02', '2020-10-26 15:56:57.100352+02', '2020-10-26 15:56:57.100352+02');
INSERT INTO public.accounts_account (id, password, date_joined, email, username, first_name, last_name, verification_code, otp_verified, is_admin, is_active, is_verified, is_banned, is_staff, is_superuser, last_login, created_at, updated_at) VALUES (15, 'pbkdf2_sha256$150000$nWreK8ZkPZBB$CgB+R5dt6ksT1FDx9JT3otpi03t3BfOMBMgF4EXoCFM=', '2020-10-26 15:57:59.346475+02', 'tes@dewkmo.com', 'tes@dewkmo.com', '', '', 0, false, false, true, false, false, false, false, '2020-10-26 15:57:59.483106+02', '2020-10-26 15:57:59.483106+02', '2020-10-26 15:57:59.483106+02');
INSERT INTO public.accounts_account (id, password, date_joined, email, username, first_name, last_name, verification_code, otp_verified, is_admin, is_active, is_verified, is_banned, is_staff, is_superuser, last_login, created_at, updated_at) VALUES (17, 'pbkdf2_sha256$150000$GwbRIh3BEqkh$34R3qMr2b6iaYe93C/AKUnXEidqZGrUTIRPs1xNxEDA=', '2020-10-26 15:58:18.94397+02', 'tes@dewkdmo.com', 'tes@dewkdmo.com', '', '', 0, false, false, true, false, false, false, false, '2020-10-26 15:58:19.079647+02', '2020-10-26 15:58:19.079647+02', '2020-10-26 15:58:19.079647+02');
INSERT INTO public.accounts_account (id, password, date_joined, email, username, first_name, last_name, verification_code, otp_verified, is_admin, is_active, is_verified, is_banned, is_staff, is_superuser, last_login, created_at, updated_at) VALUES (18, 'pbkdf2_sha256$150000$9rCGQibEf3mE$kXSxceHHPY1h8X8QMc2st9mw3ZJ6TCfKd8ZxiLhS4M0=', '2020-10-26 16:04:22.032782+02', 'tedads@kdmo.com', 'tedads@kdmo.com', '', '', 0, false, false, true, false, false, false, false, '2020-10-26 16:04:22.167422+02', '2020-10-26 16:04:22.167422+02', '2020-10-26 16:04:22.167422+02');
INSERT INTO public.accounts_account (id, password, date_joined, email, username, first_name, last_name, verification_code, otp_verified, is_admin, is_active, is_verified, is_banned, is_staff, is_superuser, last_login, created_at, updated_at) VALUES (20, 'pbkdf2_sha256$150000$OMcqcRB3eRdZ$UbJqCXUWvVWAb2WMuTrD6xEssETw2rA0OlzW45V2xkI=', '2020-10-26 16:06:39.018178+02', 'tedsads@kdmo.com', 'tedsads@kdmo.com', '', '', 0, false, false, true, false, false, false, false, '2020-10-26 16:06:39.156849+02', '2020-10-26 16:06:39.156849+02', '2020-10-26 16:06:39.156849+02');
INSERT INTO public.accounts_account (id, password, date_joined, email, username, first_name, last_name, verification_code, otp_verified, is_admin, is_active, is_verified, is_banned, is_staff, is_superuser, last_login, created_at, updated_at) VALUES (21, 'pbkdf2_sha256$150000$7QR4jOXCPd9g$BTMIN8xRI2XMDPH5H/5QAC5vUY9AldXzEStdqf+4oj4=', '2020-10-26 16:06:52.243685+02', 't7edsads@kdmo.com', 't7edsads@kdmo.com', '', '', 0, false, false, true, false, false, false, false, '2020-10-26 16:06:52.378266+02', '2020-10-26 16:06:52.378266+02', '2020-10-26 16:06:52.378266+02');
INSERT INTO public.accounts_account (id, password, date_joined, email, username, first_name, last_name, verification_code, otp_verified, is_admin, is_active, is_verified, is_banned, is_staff, is_superuser, last_login, created_at, updated_at) VALUES (22, 'pbkdf2_sha256$150000$EXmHrKnhumdC$sYIGEZO+3qg0bplVhbOFaaYwR2njHdq4JX7jLoo6fXo=', '2020-10-26 16:08:49.13377+02', 'dfasf@kdmo.com', 'dfasf@kdmo.com', '', '', 0, false, false, true, false, false, false, false, '2020-10-26 16:08:49.279356+02', '2020-10-26 16:08:49.279356+02', '2020-10-26 16:08:49.279356+02');
INSERT INTO public.accounts_account (id, password, date_joined, email, username, first_name, last_name, verification_code, otp_verified, is_admin, is_active, is_verified, is_banned, is_staff, is_superuser, last_login, created_at, updated_at) VALUES (23, 'pbkdf2_sha256$150000$4gj4p1sGwzFS$AswWo8V8UHS1azbTZ3oHgS6HhwjYGNKPURxQr63in+A=', '2020-10-26 16:10:32.677176+02', 'dfasf@kddmo.com', 'dfasf@kddmo.com', '', '', 0, false, false, true, false, false, false, false, '2020-10-26 16:10:32.818796+02', '2020-10-26 16:10:32.818796+02', '2020-10-26 16:10:32.818796+02');
INSERT INTO public.accounts_account (id, password, date_joined, email, username, first_name, last_name, verification_code, otp_verified, is_admin, is_active, is_verified, is_banned, is_staff, is_superuser, last_login, created_at, updated_at) VALUES (24, 'pbkdf2_sha256$150000$xcoBpoTnPQNp$kALs3sKvSY8qK7xVn67S0PLTICeti1U7U+vLPwLsRdY=', '2020-10-26 16:10:56.554605+02', 'dfadsf@kddmo.com', 'dfadsf@kddmo.com', '', '', 0, false, false, true, false, false, false, false, '2020-10-26 16:10:56.689258+02', '2020-10-26 16:10:56.689258+02', '2020-10-26 16:10:56.689258+02');
INSERT INTO public.accounts_account (id, password, date_joined, email, username, first_name, last_name, verification_code, otp_verified, is_admin, is_active, is_verified, is_banned, is_staff, is_superuser, last_login, created_at, updated_at) VALUES (25, 'pbkdf2_sha256$150000$JHxbGi6dqliw$igvHRPqCjqZucAe1Omf2z4FziThoC4HDWuwGYhsbAu4=', '2020-10-26 16:11:31.539571+02', 'dfad45sf@kddmo.com', 'dfad45sf@kddmo.com', '', '', 0, false, false, true, false, false, false, false, '2020-10-26 16:11:31.673213+02', '2020-10-26 16:11:31.673213+02', '2020-10-26 16:11:31.673213+02');
INSERT INTO public.accounts_account (id, password, date_joined, email, username, first_name, last_name, verification_code, otp_verified, is_admin, is_active, is_verified, is_banned, is_staff, is_superuser, last_login, created_at, updated_at) VALUES (26, 'pbkdf2_sha256$150000$bxsFfvY7HdDv$MPrTAqvlprOJh4c9HyHy8kHBhGGFYz4vcWaPOAUPf1I=', '2020-10-26 16:12:19.075869+02', 'demow@kddmo.com', 'demow@kddmo.com', '', '', 0, false, false, true, false, false, false, false, '2020-10-26 16:12:19.211507+02', '2020-10-26 16:12:19.211507+02', '2020-10-26 16:12:19.211507+02');
INSERT INTO public.accounts_account (id, password, date_joined, email, username, first_name, last_name, verification_code, otp_verified, is_admin, is_active, is_verified, is_banned, is_staff, is_superuser, last_login, created_at, updated_at) VALUES (27, 'pbkdf2_sha256$150000$fJQHrVXTxTvS$gY0veEOQBkYXt/2oa+UVMF5oyGy29hhBuHg6kqSbI3Q=', '2020-10-26 16:15:27.787917+02', 'demodw@kddmo.com', 'demodw@kddmo.com', '', '', 0, false, false, true, false, false, false, false, '2020-10-26 16:15:27.922557+02', '2020-10-26 16:15:27.922557+02', '2020-10-26 16:15:27.922557+02');
INSERT INTO public.accounts_account (id, password, date_joined, email, username, first_name, last_name, verification_code, otp_verified, is_admin, is_active, is_verified, is_banned, is_staff, is_superuser, last_login, created_at, updated_at) VALUES (28, 'pbkdf2_sha256$150000$MsDTn4WqXdS4$yAtArVOv0Sdlz0epsIa8h8GfJpWqlz6xxzFuquask8g=', '2020-10-26 16:16:46.255367+02', 'demoddw@kddmo.com', 'demoddw@kddmo.com', '', '', 0, false, false, true, false, false, false, false, '2020-10-26 16:16:46.393997+02', '2020-10-26 16:16:46.393997+02', '2020-10-26 16:16:46.393997+02');
INSERT INTO public.accounts_account (id, password, date_joined, email, username, first_name, last_name, verification_code, otp_verified, is_admin, is_active, is_verified, is_banned, is_staff, is_superuser, last_login, created_at, updated_at) VALUES (29, 'pbkdf2_sha256$150000$ICUO1LtNsy2w$N1zvuvkQzeCUpSWmR5SP/W7O74IgGbVu6Z115oKIYQ8=', '2020-10-26 16:17:43.565514+02', 'demoasdad@kddmo.com', 'demoasdad@kddmo.com', '', '', 0, false, false, true, false, false, false, false, '2020-10-26 16:17:43.700222+02', '2020-10-26 16:17:43.700222+02', '2020-10-26 16:17:43.700222+02');
INSERT INTO public.accounts_account (id, password, date_joined, email, username, first_name, last_name, verification_code, otp_verified, is_admin, is_active, is_verified, is_banned, is_staff, is_superuser, last_login, created_at, updated_at) VALUES (30, 'pbkdf2_sha256$150000$ABfuTTvJDD3d$abeikY6wceSZs47gfXd6NO2mhTvohTJRJKqjBB5RvVE=', '2020-10-26 16:20:13.057721+02', 'sdfasdf@asda.om', 'sdfasdf@asda.om', '', '', 0, false, false, true, false, false, false, false, '2020-10-26 16:20:13.193365+02', '2020-10-26 16:20:13.193365+02', '2020-10-26 16:20:13.193365+02');
INSERT INTO public.accounts_account (id, password, date_joined, email, username, first_name, last_name, verification_code, otp_verified, is_admin, is_active, is_verified, is_banned, is_staff, is_superuser, last_login, created_at, updated_at) VALUES (31, 'pbkdf2_sha256$150000$cWtS44ixeb37$0BEHIHvw6kPHRMbfeQd1DHNAFkLn1XwwFwrhTTkVh30=', '2020-10-26 16:22:01.675867+02', 'sdfasxdf@asda.om', 'sdfasxdf@asda.om', '', '', 0, false, false, true, false, false, false, false, '2020-10-26 16:22:01.810496+02', '2020-10-26 16:22:01.810496+02', '2020-10-26 16:22:01.810496+02');
INSERT INTO public.accounts_account (id, password, date_joined, email, username, first_name, last_name, verification_code, otp_verified, is_admin, is_active, is_verified, is_banned, is_staff, is_superuser, last_login, created_at, updated_at) VALUES (32, 'pbkdf2_sha256$150000$HMV2GgHXdO7S$gejn1NfKQFGskdaxbftDvpqg+UeGuJZXq6OEVeId3H0=', '2020-10-26 18:18:30.611908+02', 'testen@asda.om', 'testen@asda.om', '', '', 0, false, false, true, false, false, false, false, '2020-10-26 18:18:30.748544+02', '2020-10-26 18:18:30.748544+02', '2020-10-26 18:18:30.748544+02');
INSERT INTO public.accounts_account (id, password, date_joined, email, username, first_name, last_name, verification_code, otp_verified, is_admin, is_active, is_verified, is_banned, is_staff, is_superuser, last_login, created_at, updated_at) VALUES (36, 'pbkdf2_sha256$150000$tnkIpCMXsmOe$m/QBu9yuePGCgYDXVuxjsFG8b5Z8Dqd5bMT2V89hT7g=', '2020-10-27 15:00:26.340892+02', 'customer_upload@email.com', 'customer_upload@email.com', '', '', 0, false, false, true, false, false, false, false, '2020-10-27 15:00:26.478523+02', '2020-10-27 15:00:26.478523+02', '2020-10-27 15:00:26.478523+02');
INSERT INTO public.accounts_account (id, password, date_joined, email, username, first_name, last_name, verification_code, otp_verified, is_admin, is_active, is_verified, is_banned, is_staff, is_superuser, last_login, created_at, updated_at) VALUES (33, 'pbkdf2_sha256$150000$gdnuDM0A6eXc$oh1BGXid4R8FZ5lzUN2iLB24aZVjyzVGNDyq2vqD0ps=', '2020-10-26 18:20:25.253522+02', 'enter@asda.om', 'enter@asda.om', '', '', 0, false, false, true, true, false, true, true, '2020-10-26 18:22:09.707817+02', '2020-10-26 18:20:25.396096+02', '2020-10-26 18:22:09.707817+02');
INSERT INTO public.accounts_account (id, password, date_joined, email, username, first_name, last_name, verification_code, otp_verified, is_admin, is_active, is_verified, is_banned, is_staff, is_superuser, last_login, created_at, updated_at) VALUES (37, 'pbkdf2_sha256$150000$3LtQyXuCQsIs$coA2pW4r6o9X0rMLgb9AEKSOILE6AqbZOOh2P+pDRKA=', '2020-10-27 15:01:40.197252+02', 'customser_upload@email.com', 'customser_upload@email.com', '', '', 0, false, false, true, false, false, false, false, '2020-10-27 15:01:40.340867+02', '2020-10-27 15:01:40.340867+02', '2020-10-27 15:01:40.340867+02');
INSERT INTO public.accounts_account (id, password, date_joined, email, username, first_name, last_name, verification_code, otp_verified, is_admin, is_active, is_verified, is_banned, is_staff, is_superuser, last_login, created_at, updated_at) VALUES (38, 'pbkdf2_sha256$150000$1PgKlt8nPDtZ$wkYwdy/TeDeVjsVwUN4CuryLGYjNgtjmp/D0l+IfqWI=', '2020-10-27 15:02:58.118112+02', 'as@email.com', 'as@email.com', '', '', 0, false, false, true, false, false, false, false, '2020-10-27 15:02:58.259777+02', '2020-10-27 15:02:58.259777+02', '2020-10-27 15:02:58.259777+02');
INSERT INTO public.accounts_account (id, password, date_joined, email, username, first_name, last_name, verification_code, otp_verified, is_admin, is_active, is_verified, is_banned, is_staff, is_superuser, last_login, created_at, updated_at) VALUES (42, 'pbkdf2_sha256$150000$7xidqd4RW8lO$laE4kXc7MHKfz4IVlBGr9OXdldRX5/QC7ytw/kDsLqs=', '2020-10-27 15:17:46.627458+02', 'asddac@email.com', 'asddac@email.com', '', '', 0, false, false, true, true, false, false, false, '2020-10-27 15:17:46.768083+02', '2020-10-27 15:17:46.768083+02', '2020-10-27 15:17:46.768083+02');
INSERT INTO public.accounts_account (id, password, date_joined, email, username, first_name, last_name, verification_code, otp_verified, is_admin, is_active, is_verified, is_banned, is_staff, is_superuser, last_login, created_at, updated_at) VALUES (39, 'pbkdf2_sha256$150000$SUAMsbTMAmYu$pRKNZGKfZ8WDD0nhbN4ewAKJM3D7akQJJzcCtFR8aXM=', '2020-10-27 15:09:57.121285+02', 'ads@email.com', 'ads@email.com', '', '', 0, false, false, true, true, false, false, false, '2020-10-27 15:09:57.264902+02', '2020-10-27 15:09:57.264902+02', '2020-10-27 15:09:57.264902+02');
INSERT INTO public.accounts_account (id, password, date_joined, email, username, first_name, last_name, verification_code, otp_verified, is_admin, is_active, is_verified, is_banned, is_staff, is_superuser, last_login, created_at, updated_at) VALUES (40, 'pbkdf2_sha256$150000$BJRFKbjkpQwo$W1DUNzJuwk3D2Vi2I3XYRGU9Syo7o6xvetdiAh2yAMY=', '2020-10-27 15:15:45.221351+02', 'adss@email.com', 'adss@email.com', '', '', 0, false, false, true, true, false, false, false, '2020-10-27 15:15:45.376934+02', '2020-10-27 15:15:45.376934+02', '2020-10-27 15:15:45.376934+02');
INSERT INTO public.accounts_account (id, password, date_joined, email, username, first_name, last_name, verification_code, otp_verified, is_admin, is_active, is_verified, is_banned, is_staff, is_superuser, last_login, created_at, updated_at) VALUES (41, 'pbkdf2_sha256$150000$NzHJHCsu6MbK$7o06fLmhMIewVo1ciwB6UMrpC2tqYovQRvGsCK1m05o=', '2020-10-27 15:17:23.958737+02', 'asdda@email.com', 'asdda@email.com', '', '', 0, false, false, true, true, false, false, false, '2020-10-27 15:17:24.100402+02', '2020-10-27 15:17:24.100402+02', '2020-10-27 15:17:24.100402+02');
INSERT INTO public.accounts_account (id, password, date_joined, email, username, first_name, last_name, verification_code, otp_verified, is_admin, is_active, is_verified, is_banned, is_staff, is_superuser, last_login, created_at, updated_at) VALUES (43, 'pbkdf2_sha256$150000$1bcs6HZ2Zd8S$UwAe8SKtR28qlRYnMI0KFmMEjV8F39zHMeKKJpUdxh4=', '2020-10-27 19:48:07.816928+02', 'enterprise@mail.com', 'enterprise@mail.com', '', '', 0, false, false, true, false, false, false, false, '2020-10-27 19:48:07.954559+02', '2020-10-27 19:48:07.954559+02', '2020-10-27 19:48:07.954559+02');
INSERT INTO public.accounts_account (id, password, date_joined, email, username, first_name, last_name, verification_code, otp_verified, is_admin, is_active, is_verified, is_banned, is_staff, is_superuser, last_login, created_at, updated_at) VALUES (44, 'pbkdf2_sha256$150000$Xm073lcXFgXi$NZxoz1QXBcve7LAWgCJ2I30F0yg+TT+tp8emKZfCsCA=', '2020-10-27 19:48:22.769426+02', 'enterpr@mail.com', 'enterpr@mail.com', '', '', 0, false, false, true, false, false, false, false, '2020-10-27 19:48:22.903112+02', '2020-10-27 19:48:22.903112+02', '2020-10-27 19:48:22.903112+02');
INSERT INTO public.accounts_account (id, password, date_joined, email, username, first_name, last_name, verification_code, otp_verified, is_admin, is_active, is_verified, is_banned, is_staff, is_superuser, last_login, created_at, updated_at) VALUES (45, 'pbkdf2_sha256$150000$oYZfBh8HUrws$sCWtc16xGgfDrICFW/VxdDE6SH+Ty9JTjEZAPk4x48A=', '2020-10-27 19:48:38.985149+02', 'demo@mail.com', 'demo@mail.com', '', '', 0, false, false, true, false, false, false, false, '2020-10-27 19:48:39.124775+02', '2020-10-27 19:48:39.124775+02', '2020-10-27 19:48:39.124775+02');


--
-- Data for Name: accounts_account_groups; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- Data for Name: accounts_account_user_permissions; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- Data for Name: admin_enterprise_config; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.admin_enterprise_config (id, name, key, value, created_at, updated_at, created_by_id, updated_by_id) VALUES (1, 'Trial Configuration', 'trial_period', '15', '2020-10-27 09:34:44.478825+02', '2020-10-27 09:34:44.479822+02', NULL, NULL);
INSERT INTO public.admin_enterprise_config (id, name, key, value, created_at, updated_at, created_by_id, updated_by_id) VALUES (2, 'Trial Configuration', 'trial_period2', '15', '2020-10-27 09:51:49.007384+02', '2020-10-27 09:51:49.007384+02', NULL, NULL);
INSERT INTO public.admin_enterprise_config (id, name, key, value, created_at, updated_at, created_by_id, updated_by_id) VALUES (3, 'Trial Configuration', 'trial_period_30', '30', '2020-10-27 10:00:57.140336+02', '2020-10-27 10:00:57.140336+02', 33, 33);


--
-- Data for Name: analytics_activitylog; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.analytics_activitylog (id, username_persistent, requested_at, response_ms, path, view, view_method, remote_addr, host, method, query_params, data, response, errors, status_code, user_id, elroi_id) VALUES (1, 'Anonymous', '2020-10-31 12:25:10.7959+02', 114, '/api/v1/register/customer/E-631FA6', 'api.v1.accounts.views.RegisterCustomer', 'get', '127.0.0.1', '127.0.0.1:8000', 'GET', '{}', '{}', '{"data": {"id": 4, "title": "CCPA Request Form", "logo": "/media/87160790_859506167795177_3641859102793007104_n_RV9wNAG.jpg", "site_color": "#f2f2f2", "site_theme": "Site theme", "background_image": "/media/86479335_859506111128516_2570312921909297152_n_ofBow9q.jpg", "website_launched_to": "https://google.com", "company_name": "Individual SRL", "resident_state": false, "additional_configuration": {"input": [{"name": "is_resident", "type": "radio", "label": "I am a state resident", "values": ["Yes", "No"]}, {"name": "first_name", "type": "text", "label": "First Name"}, {"name": "kyc", "type": "file", "label": "Upload your file"}]}, "created_at": "2020-10-30T13:23:22.741775", "updated_at": "2020-10-30T13:23:22.741775", "enterprise": 8}}', NULL, 200, NULL, 'None');
INSERT INTO public.analytics_activitylog (id, username_persistent, requested_at, response_ms, path, view, view_method, remote_addr, host, method, query_params, data, response, errors, status_code, user_id, elroi_id) VALUES (2, 'Anonymous', '2020-11-01 00:59:41.475923+02', 99, '/api/v1/register/customer/E-631FA6', 'api.v1.accounts.views.RegisterCustomer', 'get', '127.0.0.1', '127.0.0.1:8000', 'GET', '{}', '{}', '{"data": {"id": 4, "title": "CCPA Request Form", "logo": "/media/87160790_859506167795177_3641859102793007104_n_RV9wNAG.jpg", "site_color": "#f2f2f2", "site_theme": "Site theme", "background_image": "/media/86479335_859506111128516_2570312921909297152_n_ofBow9q.jpg", "website_launched_to": "https://google.com", "company_name": "Individual SRL", "resident_state": false, "additional_configuration": {"input": [{"name": "is_resident", "type": "radio", "label": "I am a state resident", "values": ["Yes", "No"]}, {"name": "first_name", "type": "text", "label": "First Name"}, {"name": "kyc", "type": "file", "label": "Upload your file"}]}, "created_at": "2020-10-30T13:23:22.741775", "updated_at": "2020-10-30T13:23:22.741775", "enterprise": 8}}', NULL, 200, NULL, 'E-631FA6');
INSERT INTO public.analytics_activitylog (id, username_persistent, requested_at, response_ms, path, view, view_method, remote_addr, host, method, query_params, data, response, errors, status_code, user_id, elroi_id) VALUES (3, 'Anonymous', '2020-11-01 01:00:28.765831+02', 82, '/api/v1/register/customer/E-631FA6', 'api.v1.accounts.views.RegisterCustomer', 'get', '127.0.0.1', '127.0.0.1:8000', 'GET', '{}', '{}', '{"data": {"id": 4, "title": "CCPA Request Form", "logo": "/media/87160790_859506167795177_3641859102793007104_n_RV9wNAG.jpg", "site_color": "#f2f2f2", "site_theme": "Site theme", "background_image": "/media/86479335_859506111128516_2570312921909297152_n_ofBow9q.jpg", "website_launched_to": "https://google.com", "company_name": "Individual SRL", "resident_state": false, "additional_configuration": {"input": [{"name": "is_resident", "type": "radio", "label": "I am a state resident", "values": ["Yes", "No"]}, {"name": "first_name", "type": "text", "label": "First Name"}, {"name": "kyc", "type": "file", "label": "Upload your file"}]}, "created_at": "2020-10-30T13:23:22.741775", "updated_at": "2020-10-30T13:23:22.741775", "enterprise": 8}}', NULL, 200, NULL, 'E-631FA6');
INSERT INTO public.analytics_activitylog (id, username_persistent, requested_at, response_ms, path, view, view_method, remote_addr, host, method, query_params, data, response, errors, status_code, user_id, elroi_id) VALUES (4, 'Anonymous', '2020-11-01 01:01:15.252401+02', 93, '/api/v1/register/customer/E-631FA6', 'api.v1.accounts.views.RegisterCustomer', 'get', '127.0.0.1', '127.0.0.1:8000', 'GET', '{}', '{}', '{"data": {"id": 4, "title": "CCPA Request Form", "logo": "/media/87160790_859506167795177_3641859102793007104_n_RV9wNAG.jpg", "site_color": "#f2f2f2", "site_theme": "Site theme", "background_image": "/media/86479335_859506111128516_2570312921909297152_n_ofBow9q.jpg", "website_launched_to": "https://google.com", "company_name": "Individual SRL", "resident_state": false, "additional_configuration": {"input": [{"name": "is_resident", "type": "radio", "label": "I am a state resident", "values": ["Yes", "No"]}, {"name": "first_name", "type": "text", "label": "First Name"}, {"name": "kyc", "type": "file", "label": "Upload your file"}]}, "created_at": "2020-10-30T13:23:22.741775", "updated_at": "2020-10-30T13:23:22.741775", "enterprise": 8}}', NULL, 200, NULL, 'E-631FA6');
INSERT INTO public.analytics_activitylog (id, username_persistent, requested_at, response_ms, path, view, view_method, remote_addr, host, method, query_params, data, response, errors, status_code, user_id, elroi_id) VALUES (5, 'Anonymous', '2020-11-01 01:02:43.002959+02', 99, '/api/v1/register/customer/E-631FA6', 'api.v1.accounts.views.RegisterCustomer', 'get', '127.0.0.1', '127.0.0.1:8000', 'GET', '{}', '{}', '{"data": {"id": 4, "title": "CCPA Request Form", "logo": "/media/87160790_859506167795177_3641859102793007104_n_RV9wNAG.jpg", "site_color": "#f2f2f2", "site_theme": "Site theme", "background_image": "/media/86479335_859506111128516_2570312921909297152_n_ofBow9q.jpg", "website_launched_to": "https://google.com", "company_name": "Individual SRL", "resident_state": false, "additional_configuration": {"input": [{"name": "is_resident", "type": "radio", "label": "I am a state resident", "values": ["Yes", "No"]}, {"name": "first_name", "type": "text", "label": "First Name"}, {"name": "kyc", "type": "file", "label": "Upload your file"}]}, "created_at": "2020-10-30T13:23:22.741775", "updated_at": "2020-10-30T13:23:22.741775", "enterprise": 8}}', NULL, 200, NULL, 'E-631FA6');
INSERT INTO public.analytics_activitylog (id, username_persistent, requested_at, response_ms, path, view, view_method, remote_addr, host, method, query_params, data, response, errors, status_code, user_id, elroi_id) VALUES (6, 'Anonymous', '2020-11-01 01:10:01.050572+02', 5341, '/api/v1/login/', 'api.v1.accounts.views.LoginAPI', 'post', '127.0.0.1', '127.0.0.1:8000', 'POST', '{''email'': ''enter@asda.om'', ''password'': ''********************''}', '{''email'': ''enter@asda.om'', ''password'': ''********************''}', '{"elroi_id":"E-A20D70","email":"enter@asda.om","full_name":"Individual SRL","two_fa_valid":false,"profile":"Enterprise","tokens":{"refresh":"eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTYwNDI2NTAwMSwianRpIjoiNTQ2YThlZjM0NjZlNDQyMDk0MjliMWI4M2FmYTBjYTUiLCJ1c2VyX2lkIjozM30.7He5f_VSnDUC0TD9OOcUanzGdWSDxMAljaQEduMcxGA","access":"eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoiYWNjZXNzIiwiZXhwIjoxNjA0MTk2NjAxLCJqdGkiOiI3NGFjMDA3NWU4Y2E0ZWQ2YWI4NDhjMDg3Y2M3NmQ4ZSIsInVzZXJfaWQiOjMzfQ.tJmSLRQce3BYGRj8YdfITWsYcxkTpJHIujG-l2BZF24"}}', NULL, 206, NULL, '');
INSERT INTO public.analytics_activitylog (id, username_persistent, requested_at, response_ms, path, view, view_method, remote_addr, host, method, query_params, data, response, errors, status_code, user_id, elroi_id) VALUES (7, 'Anonymous', '2020-11-01 01:11:53.165342+02', 261, '/api/v1/login/', 'api.v1.accounts.views.LoginAPI', 'post', '127.0.0.1', '127.0.0.1:8000', 'POST', '{''email'': ''enter@asda.om'', ''password'': ''********************''}', '{''email'': ''enter@asda.om'', ''password'': ''********************''}', '{"elroi_id":"E-A20D70","email":"enter@asda.om","full_name":"Individual SRL","two_fa_valid":false,"profile":"Enterprise","tokens":{"refresh":"eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTYwNDI2NTExMywianRpIjoiYjI0ZTQ4MTA1NzQ2NGI2YWI2ODFjNTkxOWMyNzdiOTEiLCJ1c2VyX2lkIjozM30.YH8qcmEpXvLIil_wg0vhzfXE2wGsq1Yt2UO4MiAlW0U","access":"eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoiYWNjZXNzIiwiZXhwIjoxNjA0MTk2NzEzLCJqdGkiOiJmZjQwZmI2MTkyOTg0YzViYjNhMTBiNGM5NDQ0OTEyNSIsInVzZXJfaWQiOjMzfQ.K3gH0HYpqxqOYjCeeOQBnkGcd36oSTTD6PRGOzrzODU"}}', NULL, 206, NULL, 'E-A20D70');
INSERT INTO public.analytics_activitylog (id, username_persistent, requested_at, response_ms, path, view, view_method, remote_addr, host, method, query_params, data, response, errors, status_code, user_id, elroi_id) VALUES (8, 'Anonymous', '2020-11-01 01:37:36.491699+02', 252, '/api/v1/login/', 'api.v1.accounts.views.LoginAPI', 'post', '127.0.0.1', '127.0.0.1:8000', 'POST', '{''email'': ''enter@asda.om'', ''password'': ''********************''}', '{''email'': ''enter@asda.om'', ''password'': ''********************''}', '{"elroi_id":"E-A20D70","email":"enter@asda.om","full_name":"Individual SRL","two_fa_valid":false,"profile":"Enterprise","tokens":{"refresh":"eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTYwNDI2NjY1NiwianRpIjoiZTJlN2I1ZDQ5OTVmNGUzYWE2MDVkODEyOWJhMDM0NGEiLCJ1c2VyX2lkIjozM30.PyB6Oj2NgmXNFB-O_cCYH5EOj9TH6JxxHDl7XbScAjQ","access":"eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoiYWNjZXNzIiwiZXhwIjoxNjA0MTk4MjU2LCJqdGkiOiI5YTIxMjViYWE1YTg0MzdiYjhmN2RlMjAwMTI5OTA0YiIsInVzZXJfaWQiOjMzfQ.X3PnkfbSXoTCj0zhFtGiN-NQLzBHv0eulPwL4zCefII"}}', NULL, 206, NULL, 'E-A20D70');


--
-- Data for Name: analytics_analytics; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- Data for Name: auth_group; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- Data for Name: auth_group_permissions; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- Data for Name: auth_permission; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.auth_permission (id, name, content_type_id, codename) VALUES (1, 'Can add log entry', 1, 'add_logentry');
INSERT INTO public.auth_permission (id, name, content_type_id, codename) VALUES (2, 'Can change log entry', 1, 'change_logentry');
INSERT INTO public.auth_permission (id, name, content_type_id, codename) VALUES (3, 'Can delete log entry', 1, 'delete_logentry');
INSERT INTO public.auth_permission (id, name, content_type_id, codename) VALUES (4, 'Can view log entry', 1, 'view_logentry');
INSERT INTO public.auth_permission (id, name, content_type_id, codename) VALUES (5, 'Can add permission', 2, 'add_permission');
INSERT INTO public.auth_permission (id, name, content_type_id, codename) VALUES (6, 'Can change permission', 2, 'change_permission');
INSERT INTO public.auth_permission (id, name, content_type_id, codename) VALUES (7, 'Can delete permission', 2, 'delete_permission');
INSERT INTO public.auth_permission (id, name, content_type_id, codename) VALUES (8, 'Can view permission', 2, 'view_permission');
INSERT INTO public.auth_permission (id, name, content_type_id, codename) VALUES (9, 'Can add group', 3, 'add_group');
INSERT INTO public.auth_permission (id, name, content_type_id, codename) VALUES (10, 'Can change group', 3, 'change_group');
INSERT INTO public.auth_permission (id, name, content_type_id, codename) VALUES (11, 'Can delete group', 3, 'delete_group');
INSERT INTO public.auth_permission (id, name, content_type_id, codename) VALUES (12, 'Can view group', 3, 'view_group');
INSERT INTO public.auth_permission (id, name, content_type_id, codename) VALUES (13, 'Can add content type', 4, 'add_contenttype');
INSERT INTO public.auth_permission (id, name, content_type_id, codename) VALUES (14, 'Can change content type', 4, 'change_contenttype');
INSERT INTO public.auth_permission (id, name, content_type_id, codename) VALUES (15, 'Can delete content type', 4, 'delete_contenttype');
INSERT INTO public.auth_permission (id, name, content_type_id, codename) VALUES (16, 'Can view content type', 4, 'view_contenttype');
INSERT INTO public.auth_permission (id, name, content_type_id, codename) VALUES (17, 'Can add session', 5, 'add_session');
INSERT INTO public.auth_permission (id, name, content_type_id, codename) VALUES (18, 'Can change session', 5, 'change_session');
INSERT INTO public.auth_permission (id, name, content_type_id, codename) VALUES (19, 'Can delete session', 5, 'delete_session');
INSERT INTO public.auth_permission (id, name, content_type_id, codename) VALUES (20, 'Can view session', 5, 'view_session');
INSERT INTO public.auth_permission (id, name, content_type_id, codename) VALUES (21, 'Can add user', 6, 'add_account');
INSERT INTO public.auth_permission (id, name, content_type_id, codename) VALUES (22, 'Can change user', 6, 'change_account');
INSERT INTO public.auth_permission (id, name, content_type_id, codename) VALUES (23, 'Can delete user', 6, 'delete_account');
INSERT INTO public.auth_permission (id, name, content_type_id, codename) VALUES (24, 'Can view user', 6, 'view_account');
INSERT INTO public.auth_permission (id, name, content_type_id, codename) VALUES (25, 'Can add user guide', 7, 'add_userguide');
INSERT INTO public.auth_permission (id, name, content_type_id, codename) VALUES (26, 'Can change user guide', 7, 'change_userguide');
INSERT INTO public.auth_permission (id, name, content_type_id, codename) VALUES (27, 'Can delete user guide', 7, 'delete_userguide');
INSERT INTO public.auth_permission (id, name, content_type_id, codename) VALUES (28, 'Can view user guide', 7, 'view_userguide');
INSERT INTO public.auth_permission (id, name, content_type_id, codename) VALUES (29, 'Can add customer configuration', 8, 'add_customerconfiguration');
INSERT INTO public.auth_permission (id, name, content_type_id, codename) VALUES (30, 'Can change customer configuration', 8, 'change_customerconfiguration');
INSERT INTO public.auth_permission (id, name, content_type_id, codename) VALUES (31, 'Can delete customer configuration', 8, 'delete_customerconfiguration');
INSERT INTO public.auth_permission (id, name, content_type_id, codename) VALUES (32, 'Can view customer configuration', 8, 'view_customerconfiguration');
INSERT INTO public.auth_permission (id, name, content_type_id, codename) VALUES (33, 'Can add enterprise configuration model', 9, 'add_enterpriseconfigurationmodel');
INSERT INTO public.auth_permission (id, name, content_type_id, codename) VALUES (34, 'Can change enterprise configuration model', 9, 'change_enterpriseconfigurationmodel');
INSERT INTO public.auth_permission (id, name, content_type_id, codename) VALUES (35, 'Can delete enterprise configuration model', 9, 'delete_enterpriseconfigurationmodel');
INSERT INTO public.auth_permission (id, name, content_type_id, codename) VALUES (36, 'Can view enterprise configuration model', 9, 'view_enterpriseconfigurationmodel');
INSERT INTO public.auth_permission (id, name, content_type_id, codename) VALUES (37, 'Can add consumer request', 10, 'add_consumerrequest');
INSERT INTO public.auth_permission (id, name, content_type_id, codename) VALUES (38, 'Can change consumer request', 10, 'change_consumerrequest');
INSERT INTO public.auth_permission (id, name, content_type_id, codename) VALUES (39, 'Can delete consumer request', 10, 'delete_consumerrequest');
INSERT INTO public.auth_permission (id, name, content_type_id, codename) VALUES (40, 'Can view consumer request', 10, 'view_consumerrequest');
INSERT INTO public.auth_permission (id, name, content_type_id, codename) VALUES (41, 'Can add TOTP device', 11, 'add_totpdevice');
INSERT INTO public.auth_permission (id, name, content_type_id, codename) VALUES (42, 'Can change TOTP device', 11, 'change_totpdevice');
INSERT INTO public.auth_permission (id, name, content_type_id, codename) VALUES (43, 'Can delete TOTP device', 11, 'delete_totpdevice');
INSERT INTO public.auth_permission (id, name, content_type_id, codename) VALUES (44, 'Can view TOTP device', 11, 'view_totpdevice');
INSERT INTO public.auth_permission (id, name, content_type_id, codename) VALUES (45, 'Can add static device', 12, 'add_staticdevice');
INSERT INTO public.auth_permission (id, name, content_type_id, codename) VALUES (46, 'Can change static device', 12, 'change_staticdevice');
INSERT INTO public.auth_permission (id, name, content_type_id, codename) VALUES (47, 'Can delete static device', 12, 'delete_staticdevice');
INSERT INTO public.auth_permission (id, name, content_type_id, codename) VALUES (48, 'Can view static device', 12, 'view_staticdevice');
INSERT INTO public.auth_permission (id, name, content_type_id, codename) VALUES (49, 'Can add static token', 13, 'add_statictoken');
INSERT INTO public.auth_permission (id, name, content_type_id, codename) VALUES (50, 'Can change static token', 13, 'change_statictoken');
INSERT INTO public.auth_permission (id, name, content_type_id, codename) VALUES (51, 'Can delete static token', 13, 'delete_statictoken');
INSERT INTO public.auth_permission (id, name, content_type_id, codename) VALUES (52, 'Can view static token', 13, 'view_statictoken');
INSERT INTO public.auth_permission (id, name, content_type_id, codename) VALUES (53, 'Can add blacklisted token', 14, 'add_blacklistedtoken');
INSERT INTO public.auth_permission (id, name, content_type_id, codename) VALUES (54, 'Can change blacklisted token', 14, 'change_blacklistedtoken');
INSERT INTO public.auth_permission (id, name, content_type_id, codename) VALUES (55, 'Can delete blacklisted token', 14, 'delete_blacklistedtoken');
INSERT INTO public.auth_permission (id, name, content_type_id, codename) VALUES (56, 'Can view blacklisted token', 14, 'view_blacklistedtoken');
INSERT INTO public.auth_permission (id, name, content_type_id, codename) VALUES (57, 'Can add outstanding token', 15, 'add_outstandingtoken');
INSERT INTO public.auth_permission (id, name, content_type_id, codename) VALUES (58, 'Can change outstanding token', 15, 'change_outstandingtoken');
INSERT INTO public.auth_permission (id, name, content_type_id, codename) VALUES (59, 'Can delete outstanding token', 15, 'delete_outstandingtoken');
INSERT INTO public.auth_permission (id, name, content_type_id, codename) VALUES (60, 'Can view outstanding token', 15, 'view_outstandingtoken');
INSERT INTO public.auth_permission (id, name, content_type_id, codename) VALUES (61, 'Can add user guide uploads', 16, 'add_userguideuploads');
INSERT INTO public.auth_permission (id, name, content_type_id, codename) VALUES (62, 'Can change user guide uploads', 16, 'change_userguideuploads');
INSERT INTO public.auth_permission (id, name, content_type_id, codename) VALUES (63, 'Can delete user guide uploads', 16, 'delete_userguideuploads');
INSERT INTO public.auth_permission (id, name, content_type_id, codename) VALUES (64, 'Can view user guide uploads', 16, 'view_userguideuploads');
INSERT INTO public.auth_permission (id, name, content_type_id, codename) VALUES (65, 'Can add user guide model', 17, 'add_userguidemodel');
INSERT INTO public.auth_permission (id, name, content_type_id, codename) VALUES (66, 'Can change user guide model', 17, 'change_userguidemodel');
INSERT INTO public.auth_permission (id, name, content_type_id, codename) VALUES (67, 'Can delete user guide model', 17, 'delete_userguidemodel');
INSERT INTO public.auth_permission (id, name, content_type_id, codename) VALUES (68, 'Can view user guide model', 17, 'view_userguidemodel');
INSERT INTO public.auth_permission (id, name, content_type_id, codename) VALUES (69, 'Can add analytics', 18, 'add_analytics');
INSERT INTO public.auth_permission (id, name, content_type_id, codename) VALUES (70, 'Can change analytics', 18, 'change_analytics');
INSERT INTO public.auth_permission (id, name, content_type_id, codename) VALUES (71, 'Can delete analytics', 18, 'delete_analytics');
INSERT INTO public.auth_permission (id, name, content_type_id, codename) VALUES (72, 'Can view analytics', 18, 'view_analytics');
INSERT INTO public.auth_permission (id, name, content_type_id, codename) VALUES (73, 'Can add enterprise', 19, 'add_enterprise');
INSERT INTO public.auth_permission (id, name, content_type_id, codename) VALUES (74, 'Can change enterprise', 19, 'change_enterprise');
INSERT INTO public.auth_permission (id, name, content_type_id, codename) VALUES (75, 'Can delete enterprise', 19, 'delete_enterprise');
INSERT INTO public.auth_permission (id, name, content_type_id, codename) VALUES (76, 'Can view enterprise', 19, 'view_enterprise');
INSERT INTO public.auth_permission (id, name, content_type_id, codename) VALUES (77, 'Can add customer', 20, 'add_customer');
INSERT INTO public.auth_permission (id, name, content_type_id, codename) VALUES (78, 'Can change customer', 20, 'change_customer');
INSERT INTO public.auth_permission (id, name, content_type_id, codename) VALUES (79, 'Can delete customer', 20, 'delete_customer');
INSERT INTO public.auth_permission (id, name, content_type_id, codename) VALUES (80, 'Can view customer', 20, 'view_customer');
INSERT INTO public.auth_permission (id, name, content_type_id, codename) VALUES (81, 'Can add admin enterprise config', 21, 'add_adminenterpriseconfig');
INSERT INTO public.auth_permission (id, name, content_type_id, codename) VALUES (82, 'Can change admin enterprise config', 21, 'change_adminenterpriseconfig');
INSERT INTO public.auth_permission (id, name, content_type_id, codename) VALUES (83, 'Can delete admin enterprise config', 21, 'delete_adminenterpriseconfig');
INSERT INTO public.auth_permission (id, name, content_type_id, codename) VALUES (84, 'Can view admin enterprise config', 21, 'view_adminenterpriseconfig');
INSERT INTO public.auth_permission (id, name, content_type_id, codename) VALUES (85, 'Can add customer uploads', 22, 'add_customeruploads');
INSERT INTO public.auth_permission (id, name, content_type_id, codename) VALUES (86, 'Can change customer uploads', 22, 'change_customeruploads');
INSERT INTO public.auth_permission (id, name, content_type_id, codename) VALUES (87, 'Can delete customer uploads', 22, 'delete_customeruploads');
INSERT INTO public.auth_permission (id, name, content_type_id, codename) VALUES (88, 'Can view customer uploads', 22, 'view_customeruploads');
INSERT INTO public.auth_permission (id, name, content_type_id, codename) VALUES (89, 'Can add Api logs', 23, 'add_activitylog');
INSERT INTO public.auth_permission (id, name, content_type_id, codename) VALUES (90, 'Can change Api logs', 23, 'change_activitylog');
INSERT INTO public.auth_permission (id, name, content_type_id, codename) VALUES (91, 'Can delete Api logs', 23, 'delete_activitylog');
INSERT INTO public.auth_permission (id, name, content_type_id, codename) VALUES (92, 'Can view Api logs', 23, 'view_activitylog');


--
-- Data for Name: consumer_requests; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.consumer_requests (id, elroi_id, title, request_type, description, is_data_subject_name, status, process_end_date, request_date, approved_date, extend_requested, extend_requested_date, extend_requested_days, created_at, updated_at, customer_id, enterprise_id, request_form) VALUES (2, '234-629-5667', NULL, 0, NULL, false, 1, '2020-12-11 19:37:44.103397+02', '2020-10-27 19:37:44.103397+02', NULL, false, NULL, 0, '2020-10-27 19:37:44.103397+02', '2020-10-27 19:37:44.103397+02', 22, 1, NULL);
INSERT INTO public.consumer_requests (id, elroi_id, title, request_type, description, is_data_subject_name, status, process_end_date, request_date, approved_date, extend_requested, extend_requested_date, extend_requested_days, created_at, updated_at, customer_id, enterprise_id, request_form) VALUES (3, '153-230-5126', NULL, 0, NULL, false, 1, '2020-12-11 19:38:51.521521+02', '2020-10-27 19:38:51.521521+02', NULL, false, NULL, 0, '2020-10-27 19:38:51.522566+02', '2020-10-27 19:38:51.522566+02', 21, 1, NULL);
INSERT INTO public.consumer_requests (id, elroi_id, title, request_type, description, is_data_subject_name, status, process_end_date, request_date, approved_date, extend_requested, extend_requested_date, extend_requested_days, created_at, updated_at, customer_id, enterprise_id, request_form) VALUES (4, '933-660-0370', NULL, 0, NULL, false, 1, '2020-12-11 19:38:58.322579+02', '2020-10-27 19:38:58.322579+02', NULL, false, NULL, 0, '2020-10-27 19:38:58.323577+02', '2020-10-27 19:38:58.323577+02', 20, 1, NULL);
INSERT INTO public.consumer_requests (id, elroi_id, title, request_type, description, is_data_subject_name, status, process_end_date, request_date, approved_date, extend_requested, extend_requested_date, extend_requested_days, created_at, updated_at, customer_id, enterprise_id, request_form) VALUES (5, '580-473-3871', NULL, 0, NULL, false, 1, '2020-12-11 19:39:06.253372+02', '2020-10-27 19:39:06.253372+02', NULL, false, NULL, 0, '2020-10-27 19:39:06.253372+02', '2020-10-27 19:39:06.253372+02', 20, 1, NULL);
INSERT INTO public.consumer_requests (id, elroi_id, title, request_type, description, is_data_subject_name, status, process_end_date, request_date, approved_date, extend_requested, extend_requested_date, extend_requested_days, created_at, updated_at, customer_id, enterprise_id, request_form) VALUES (6, '134-334-6216', NULL, 0, NULL, false, 0, '2020-12-11 19:39:18.086405+02', '2020-10-27 19:39:18.086405+02', NULL, false, NULL, 0, '2020-10-27 19:39:18.087461+02', '2020-10-27 19:39:18.087461+02', 20, 1, NULL);
INSERT INTO public.consumer_requests (id, elroi_id, title, request_type, description, is_data_subject_name, status, process_end_date, request_date, approved_date, extend_requested, extend_requested_date, extend_requested_days, created_at, updated_at, customer_id, enterprise_id, request_form) VALUES (7, '406-141-4517', NULL, 0, NULL, false, 0, '2020-12-11 19:39:23.905725+02', '2020-10-27 19:39:23.905725+02', NULL, false, NULL, 0, '2020-10-27 19:39:23.905725+02', '2020-10-27 19:39:23.905725+02', 22, 1, NULL);
INSERT INTO public.consumer_requests (id, elroi_id, title, request_type, description, is_data_subject_name, status, process_end_date, request_date, approved_date, extend_requested, extend_requested_date, extend_requested_days, created_at, updated_at, customer_id, enterprise_id, request_form) VALUES (8, '518-779-8914', NULL, 0, NULL, false, 0, '2020-12-11 19:39:53.178848+02', '2020-10-27 19:39:53.178848+02', NULL, false, NULL, 0, '2020-10-27 19:39:53.178848+02', '2020-10-27 19:39:53.178848+02', 22, 1, NULL);
INSERT INTO public.consumer_requests (id, elroi_id, title, request_type, description, is_data_subject_name, status, process_end_date, request_date, approved_date, extend_requested, extend_requested_date, extend_requested_days, created_at, updated_at, customer_id, enterprise_id, request_form) VALUES (9, '479-276-0896', 'Test Request', 0, 'Test Despcrition', false, 0, '2020-12-11 19:40:21.699356+02', '2020-10-27 19:40:21.699356+02', NULL, false, NULL, 0, '2020-10-27 19:40:21.699356+02', '2020-10-27 19:40:21.699356+02', 22, 1, NULL);
INSERT INTO public.consumer_requests (id, elroi_id, title, request_type, description, is_data_subject_name, status, process_end_date, request_date, approved_date, extend_requested, extend_requested_date, extend_requested_days, created_at, updated_at, customer_id, enterprise_id, request_form) VALUES (10, '679-761-3206', 'Test Request', 0, 'Test Despcrition', false, 0, '2020-12-11 19:49:19.962321+02', '2020-10-27 19:49:19.962321+02', NULL, false, NULL, 0, '2020-10-27 19:49:19.962321+02', '2020-10-27 19:49:19.962321+02', 22, 6, NULL);
INSERT INTO public.consumer_requests (id, elroi_id, title, request_type, description, is_data_subject_name, status, process_end_date, request_date, approved_date, extend_requested, extend_requested_date, extend_requested_days, created_at, updated_at, customer_id, enterprise_id, request_form) VALUES (11, '713-389-3441', 'Test Request', 0, 'Test Despcrition', false, 1, '2020-12-11 19:49:29.415906+02', '2020-10-27 19:49:29.415906+02', NULL, false, NULL, 0, '2020-10-27 19:49:29.415906+02', '2020-10-27 19:49:29.415906+02', 22, 6, NULL);
INSERT INTO public.consumer_requests (id, elroi_id, title, request_type, description, is_data_subject_name, status, process_end_date, request_date, approved_date, extend_requested, extend_requested_date, extend_requested_days, created_at, updated_at, customer_id, enterprise_id, request_form) VALUES (12, '393-395-7828', 'Test Request', 0, 'Test Despcrition', false, 1, '2020-12-11 19:49:36.107884+02', '2020-10-27 19:49:36.107884+02', NULL, false, NULL, 0, '2020-10-27 19:49:36.107884+02', '2020-10-27 19:49:36.107884+02', 22, 6, NULL);
INSERT INTO public.consumer_requests (id, elroi_id, title, request_type, description, is_data_subject_name, status, process_end_date, request_date, approved_date, extend_requested, extend_requested_date, extend_requested_days, created_at, updated_at, customer_id, enterprise_id, request_form) VALUES (13, '887-836-9968', 'Test Request', 0, 'Test Despcrition', false, 1, '2020-12-11 19:49:40.983865+02', '2020-10-27 19:49:40.983865+02', NULL, false, NULL, 0, '2020-10-27 19:49:40.983865+02', '2020-10-27 19:49:40.983865+02', 22, 7, NULL);
INSERT INTO public.consumer_requests (id, elroi_id, title, request_type, description, is_data_subject_name, status, process_end_date, request_date, approved_date, extend_requested, extend_requested_date, extend_requested_days, created_at, updated_at, customer_id, enterprise_id, request_form) VALUES (14, '775-608-4389', 'Test Request', 0, 'Test Despcrition', false, 0, '2020-12-11 19:49:45.612828+02', '2020-10-27 19:49:45.612828+02', NULL, false, NULL, 0, '2020-10-27 19:49:45.613776+02', '2020-10-27 19:49:45.613776+02', 22, 7, NULL);
INSERT INTO public.consumer_requests (id, elroi_id, title, request_type, description, is_data_subject_name, status, process_end_date, request_date, approved_date, extend_requested, extend_requested_date, extend_requested_days, created_at, updated_at, customer_id, enterprise_id, request_form) VALUES (15, '884-229-4015', 'Test Request', 0, 'Test Despcrition', false, 0, '2020-12-11 19:50:11.218126+02', '2020-10-27 19:50:11.218126+02', NULL, false, NULL, 0, '2020-10-27 19:50:11.218126+02', '2020-10-27 19:50:11.218126+02', 21, 8, NULL);
INSERT INTO public.consumer_requests (id, elroi_id, title, request_type, description, is_data_subject_name, status, process_end_date, request_date, approved_date, extend_requested, extend_requested_date, extend_requested_days, created_at, updated_at, customer_id, enterprise_id, request_form) VALUES (16, '565-599-1330', 'Test Request', 0, 'Test Despcrition', false, 1, '2020-12-11 19:50:17.715443+02', '2020-10-27 19:50:17.715443+02', NULL, false, NULL, 0, '2020-10-27 19:50:17.716439+02', '2020-10-27 19:50:17.716439+02', 21, 8, NULL);
INSERT INTO public.consumer_requests (id, elroi_id, title, request_type, description, is_data_subject_name, status, process_end_date, request_date, approved_date, extend_requested, extend_requested_date, extend_requested_days, created_at, updated_at, customer_id, enterprise_id, request_form) VALUES (17, '442-770-2113', 'Test Request', 0, 'Test Despcrition', false, 1, '2020-12-11 19:50:21.441469+02', '2020-10-27 19:50:21.441469+02', NULL, false, NULL, 0, '2020-10-27 19:50:21.441469+02', '2020-10-27 19:50:21.441469+02', 21, 8, NULL);
INSERT INTO public.consumer_requests (id, elroi_id, title, request_type, description, is_data_subject_name, status, process_end_date, request_date, approved_date, extend_requested, extend_requested_date, extend_requested_days, created_at, updated_at, customer_id, enterprise_id, request_form) VALUES (18, '463-305-5422', 'Test Request', 0, 'Test Despcrition', false, 1, '2020-12-11 19:50:25.422654+02', '2020-10-27 19:50:25.421696+02', NULL, false, NULL, 0, '2020-10-27 19:50:25.422654+02', '2020-10-27 19:50:25.422654+02', 20, 8, NULL);
INSERT INTO public.consumer_requests (id, elroi_id, title, request_type, description, is_data_subject_name, status, process_end_date, request_date, approved_date, extend_requested, extend_requested_date, extend_requested_days, created_at, updated_at, customer_id, enterprise_id, request_form) VALUES (19, '655-548-8209', 'Test Request', 0, 'Test Despcrition', false, 1, '2020-12-11 19:50:27.475849+02', '2020-10-27 19:50:27.475849+02', NULL, false, NULL, 0, '2020-10-27 19:50:27.475849+02', '2020-10-27 19:50:27.475849+02', 20, 8, NULL);
INSERT INTO public.consumer_requests (id, elroi_id, title, request_type, description, is_data_subject_name, status, process_end_date, request_date, approved_date, extend_requested, extend_requested_date, extend_requested_days, created_at, updated_at, customer_id, enterprise_id, request_form) VALUES (22, '286-731-6963', NULL, 0, NULL, false, 1, '2020-12-13 19:46:04.681924+02', '2020-10-29 19:46:04.681924+02', NULL, false, NULL, 0, '2020-10-29 19:46:04.681924+02', '2020-10-29 19:46:04.681924+02', 23, 1, NULL);
INSERT INTO public.consumer_requests (id, elroi_id, title, request_type, description, is_data_subject_name, status, process_end_date, request_date, approved_date, extend_requested, extend_requested_date, extend_requested_days, created_at, updated_at, customer_id, enterprise_id, request_form) VALUES (23, '894-214-5318', NULL, 0, NULL, false, 1, '2020-12-13 19:48:13.407061+02', '2020-10-29 19:48:13.407061+02', NULL, false, NULL, 0, '2020-10-29 19:48:13.407061+02', '2020-10-29 19:48:13.407061+02', 23, 1, NULL);
INSERT INTO public.consumer_requests (id, elroi_id, title, request_type, description, is_data_subject_name, status, process_end_date, request_date, approved_date, extend_requested, extend_requested_date, extend_requested_days, created_at, updated_at, customer_id, enterprise_id, request_form) VALUES (24, '361-584-2906', NULL, 0, NULL, false, 0, '2020-12-14 17:16:32.607682+02', '2020-10-30 17:16:32.607682+02', NULL, false, NULL, 0, '2020-10-30 17:16:32.608719+02', '2020-10-30 17:16:32.608719+02', 29, 8, '{"input": [{"name": "is_resident", "type": "radio", "label": "I am a state resident", "value": "no"}, {"name": "first_name", "type": "text", "label": "First Name", "value": "First"}, {"name": "kyc", "type": "file", "label": "Upload your file", "value": "86802883_859506094461851_4560743604603060224_n.jpg"}]}');
INSERT INTO public.consumer_requests (id, elroi_id, title, request_type, description, is_data_subject_name, status, process_end_date, request_date, approved_date, extend_requested, extend_requested_date, extend_requested_days, created_at, updated_at, customer_id, enterprise_id, request_form) VALUES (25, '209-645-0092', NULL, 0, NULL, false, 0, '2020-12-14 17:17:05.903635+02', '2020-10-30 17:17:05.903635+02', NULL, false, NULL, 0, '2020-10-30 17:17:05.903635+02', '2020-10-30 17:17:05.903635+02', 30, 8, '"{''input'': [{''type'': ''radio'', ''name'': ''is_resident'', ''label'': ''I am a state resident'', ''value'': ''no''}, {''type'': ''text'', ''name'': ''first_name'', ''label'': ''First Name'', ''value'': ''First''}, {''type'': ''file'', ''name'': ''kyc'', ''label'': ''Upload your file'', ''value'': ''86802883_859506094461851_4560743604603060224_n.jpg''}]}"');
INSERT INTO public.consumer_requests (id, elroi_id, title, request_type, description, is_data_subject_name, status, process_end_date, request_date, approved_date, extend_requested, extend_requested_date, extend_requested_days, created_at, updated_at, customer_id, enterprise_id, request_form) VALUES (26, '985-553-5471', NULL, 0, NULL, false, 0, '2020-12-14 17:17:32.653023+02', '2020-10-30 17:17:32.653023+02', NULL, false, NULL, 0, '2020-10-30 17:17:32.653023+02', '2020-10-30 17:17:32.653023+02', 31, 8, '"{\"input\": [{\"type\": \"radio\", \"name\": \"is_resident\", \"label\": \"I am a state resident\", \"value\": \"no\"}, {\"type\": \"text\", \"name\": \"first_name\", \"label\": \"First Name\", \"value\": \"First\"}, {\"type\": \"file\", \"name\": \"kyc\", \"label\": \"Upload your file\", \"value\": \"86802883_859506094461851_4560743604603060224_n.jpg\"}]}"');
INSERT INTO public.consumer_requests (id, elroi_id, title, request_type, description, is_data_subject_name, status, process_end_date, request_date, approved_date, extend_requested, extend_requested_date, extend_requested_days, created_at, updated_at, customer_id, enterprise_id, request_form) VALUES (27, '346-331-6147', NULL, 0, NULL, false, 0, '2020-12-14 17:19:52.214355+02', '2020-10-30 17:19:52.214355+02', NULL, false, NULL, 0, '2020-10-30 17:19:52.214355+02', '2020-10-30 17:19:52.214355+02', 32, 8, '{"input": [{"name": "is_resident", "type": "radio", "label": "I am a state resident", "value": "no"}, {"name": "first_name", "type": "text", "label": "First Name", "value": "First"}, {"name": "kyc", "type": "file", "label": "Upload your file", "value": "86802883_859506094461851_4560743604603060224_n.jpg"}]}');
INSERT INTO public.consumer_requests (id, elroi_id, title, request_type, description, is_data_subject_name, status, process_end_date, request_date, approved_date, extend_requested, extend_requested_date, extend_requested_days, created_at, updated_at, customer_id, enterprise_id, request_form) VALUES (28, '730-602-9697', NULL, 0, NULL, false, 0, '2020-12-14 17:21:28.411924+02', '2020-10-30 17:21:28.411924+02', NULL, false, NULL, 0, '2020-10-30 17:21:28.411924+02', '2020-10-30 17:21:28.411924+02', 33, 8, '{"input": [{"name": "is_resident", "type": "radio", "label": "I am a state resident", "value": "no"}, {"name": "first_name", "type": "text", "label": "First Name", "value": "First"}, {"name": "kyc", "type": "file", "label": "Upload your file", "value": "86802883_859506094461851_4560743604603060224_n.jpg"}]}');


--
-- Data for Name: customer_uploads; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- Data for Name: customers; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.customers (id, elroi_id, email, first_name, last_name, state_resident, created_at, user_id, file, additional_fields) VALUES (2, 'asdfasdfa', 'tes@dewkdmo.com', 'First_name', 'Last-name', false, '2020-10-26 15:58:19.082599+02', 17, 'test.png', '1');
INSERT INTO public.customers (id, elroi_id, email, first_name, last_name, state_resident, created_at, user_id, file, additional_fields) VALUES (6, NULL, 'dfasf@kdmo.com', 'First_name', 'Last-name', false, '2020-10-26 16:08:49.287335+02', 22, 'test.png', '1');
INSERT INTO public.customers (id, elroi_id, email, first_name, last_name, state_resident, created_at, user_id, file, additional_fields) VALUES (7, NULL, 'dfasf@kddmo.com', 'First_name', 'Last-name', false, '2020-10-26 16:10:32.834754+02', 23, 'test.png', '1');
INSERT INTO public.customers (id, elroi_id, email, first_name, last_name, state_resident, created_at, user_id, file, additional_fields) VALUES (8, NULL, 'dfadsf@kddmo.com', 'First_name', 'Last-name', false, '2020-10-26 16:10:56.69726+02', 24, 'test.png', '1');
INSERT INTO public.customers (id, elroi_id, email, first_name, last_name, state_resident, created_at, user_id, file, additional_fields) VALUES (9, NULL, 'dfad45sf@kddmo.com', 'First_name', 'Last-name', false, '2020-10-26 16:11:31.682189+02', 25, 'test.png', '1');
INSERT INTO public.customers (id, elroi_id, email, first_name, last_name, state_resident, created_at, user_id, file, additional_fields) VALUES (10, NULL, 'demow@kddmo.com', 'First_name', 'Last-name', false, '2020-10-26 16:12:19.220468+02', 26, 'test.png', '1');
INSERT INTO public.customers (id, elroi_id, email, first_name, last_name, state_resident, created_at, user_id, file, additional_fields) VALUES (11, NULL, 'demodw@kddmo.com', 'First_name', 'Last-name', false, '2020-10-26 16:15:27.940509+02', 27, 'test.png', '1');
INSERT INTO public.customers (id, elroi_id, email, first_name, last_name, state_resident, created_at, user_id, file, additional_fields) VALUES (12, 'C-A35DB9', 'demoddw@kddmo.com', 'First_name', 'Last-name', false, '2020-10-26 16:16:46.401964+02', 28, 'test.png', '1');
INSERT INTO public.customers (id, elroi_id, email, first_name, last_name, state_resident, created_at, user_id, file, additional_fields) VALUES (13, 'C-D78B92', 'demoasdad@kddmo.com', 'First_name', 'Last-name', false, '2020-10-26 16:17:43.710134+02', 29, 'test.png', '1');
INSERT INTO public.customers (id, elroi_id, email, first_name, last_name, state_resident, created_at, user_id, file, additional_fields) VALUES (14, NULL, 'sdfasdf@asda.om', 'First_name', 'Last-name', false, '2020-10-26 16:20:13.202273+02', 30, 'test.png', '1');
INSERT INTO public.customers (id, elroi_id, email, first_name, last_name, state_resident, created_at, user_id, file, additional_fields) VALUES (15, 'C-2FE787', 'sdfasxdf@asda.om', 'First_name', 'Last-name', false, '2020-10-26 16:22:01.820438+02', 31, 'test.png', '1');
INSERT INTO public.customers (id, elroi_id, email, first_name, last_name, state_resident, created_at, user_id, file, additional_fields) VALUES (16, 'C-43E0C1', 'customer_upload@email.com', 'Alexandru', 'Lesan', true, '2020-10-27 15:00:26.49448+02', 36, 'test.png', '1');
INSERT INTO public.customers (id, elroi_id, email, first_name, last_name, state_resident, created_at, user_id, file, additional_fields) VALUES (17, 'C-92FB02', 'customser_upload@email.com', 'Alexandru', 'Lesan', true, '2020-10-27 15:01:40.357172+02', 37, 'test.png', '1');
INSERT INTO public.customers (id, elroi_id, email, first_name, last_name, state_resident, created_at, user_id, file, additional_fields) VALUES (18, 'C-0D6DCD', 'as@email.com', 'Alexandru', 'Lesan', true, '2020-10-27 15:02:58.268767+02', 38, 'test.png', '1');
INSERT INTO public.customers (id, elroi_id, email, first_name, last_name, state_resident, created_at, user_id, file, additional_fields) VALUES (19, 'C-743AC0', 'ads@email.com', 'Alexandru', 'Lesan', true, '2020-10-27 15:09:57.274875+02', 39, 'test.png', '1');
INSERT INTO public.customers (id, elroi_id, email, first_name, last_name, state_resident, created_at, user_id, file, additional_fields) VALUES (20, 'C-A40D80', 'adss@email.com', 'Alexandru', 'Lesan', true, '2020-10-27 15:15:45.395832+02', 40, '2035.jpg', '1');
INSERT INTO public.customers (id, elroi_id, email, first_name, last_name, state_resident, created_at, user_id, file, additional_fields) VALUES (21, 'C-0BABC5', 'asdda@email.com', 'Alexandru', 'Lesan', true, '2020-10-27 15:17:24.11133+02', 41, '2035_4IP2cyk.jpg', '1');
INSERT INTO public.customers (id, elroi_id, email, first_name, last_name, state_resident, created_at, user_id, file, additional_fields) VALUES (22, 'C-AC8350', 'asddac@email.com', 'Alexandru', 'Lesan', true, '2020-10-27 15:17:46.780051+02', 42, '2035_Gur6KnI.jpg', '1');
INSERT INTO public.customers (id, elroi_id, email, first_name, last_name, state_resident, created_at, user_id, file, additional_fields) VALUES (23, 'C-FEFC04', 'customer@email.com', NULL, NULL, false, '2020-10-29 18:12:44.608974+02', NULL, '', '1');
INSERT INTO public.customers (id, elroi_id, email, first_name, last_name, state_resident, created_at, user_id, file, additional_fields) VALUES (29, 'C-F72B16', 'igiigeefke@ajiecf.elroi.user', 'First', '', false, '2020-10-30 17:16:32.595714+02', NULL, '86802883_859506094461851_4560743604603060224_n.jpg', '{"input": [{"name": "is_resident", "type": "radio", "label": "I am a state resident", "value": "no"}, {"name": "first_name", "type": "text", "label": "First Name", "value": "First"}, {"name": "kyc", "type": "file", "label": "Upload your file", "value": "86802883_859506094461851_4560743604603060224_n.jpg"}]}');
INSERT INTO public.customers (id, elroi_id, email, first_name, last_name, state_resident, created_at, user_id, file, additional_fields) VALUES (30, 'C-7DE95F', 'hcekbidihk@kkdhhk.elroi.user', 'First', '', false, '2020-10-30 17:17:05.896651+02', NULL, '86802883_859506094461851_4560743604603060224_n.jpg', '{"input": [{"name": "is_resident", "type": "radio", "label": "I am a state resident", "value": "no"}, {"name": "first_name", "type": "text", "label": "First Name", "value": "First"}, {"name": "kyc", "type": "file", "label": "Upload your file", "value": "86802883_859506094461851_4560743604603060224_n.jpg"}]}');
INSERT INTO public.customers (id, elroi_id, email, first_name, last_name, state_resident, created_at, user_id, file, additional_fields) VALUES (31, 'C-BCD072', 'dihighcgkh@hickab.elroi.user', 'First', '', false, '2020-10-30 17:17:32.645898+02', NULL, '86802883_859506094461851_4560743604603060224_n.jpg', '{"input": [{"name": "is_resident", "type": "radio", "label": "I am a state resident", "value": "no"}, {"name": "first_name", "type": "text", "label": "First Name", "value": "First"}, {"name": "kyc", "type": "file", "label": "Upload your file", "value": "86802883_859506094461851_4560743604603060224_n.jpg"}]}');
INSERT INTO public.customers (id, elroi_id, email, first_name, last_name, state_resident, created_at, user_id, file, additional_fields) VALUES (32, 'C-11CE44', 'ejhdlaigdf@jkhgei.elroi.user', 'First', '', false, '2020-10-30 17:19:52.207376+02', NULL, '86802883_859506094461851_4560743604603060224_n.jpg', '{"input": [{"name": "is_resident", "type": "radio", "label": "I am a state resident", "value": "no"}, {"name": "first_name", "type": "text", "label": "First Name", "value": "First"}, {"name": "kyc", "type": "file", "label": "Upload your file", "value": "86802883_859506094461851_4560743604603060224_n.jpg"}]}');
INSERT INTO public.customers (id, elroi_id, email, first_name, last_name, state_resident, created_at, user_id, file, additional_fields) VALUES (33, 'C-BB2AE2', 'bfgfeafagb_1604064088.402963@clfkha.elroi.user', 'First', '', false, '2020-10-30 17:21:28.405899+02', NULL, '86802883_859506094461851_4560743604603060224_n.jpg', '{"input": [{"name": "is_resident", "type": "radio", "label": "I am a state resident", "value": "no"}, {"name": "first_name", "type": "text", "label": "First Name", "value": "First"}, {"name": "kyc", "type": "file", "label": "Upload your file", "value": "86802883_859506094461851_4560743604603060224_n.jpg"}]}');


--
-- Data for Name: django_admin_log; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- Data for Name: django_content_type; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.django_content_type (id, app_label, model) VALUES (1, 'admin', 'logentry');
INSERT INTO public.django_content_type (id, app_label, model) VALUES (2, 'auth', 'permission');
INSERT INTO public.django_content_type (id, app_label, model) VALUES (3, 'auth', 'group');
INSERT INTO public.django_content_type (id, app_label, model) VALUES (4, 'contenttypes', 'contenttype');
INSERT INTO public.django_content_type (id, app_label, model) VALUES (5, 'sessions', 'session');
INSERT INTO public.django_content_type (id, app_label, model) VALUES (6, 'accounts', 'account');
INSERT INTO public.django_content_type (id, app_label, model) VALUES (7, 'enterprise', 'userguide');
INSERT INTO public.django_content_type (id, app_label, model) VALUES (8, 'enterprise', 'customerconfiguration');
INSERT INTO public.django_content_type (id, app_label, model) VALUES (9, 'enterprise', 'enterpriseconfigurationmodel');
INSERT INTO public.django_content_type (id, app_label, model) VALUES (10, 'consumer_request', 'consumerrequest');
INSERT INTO public.django_content_type (id, app_label, model) VALUES (11, 'otp_totp', 'totpdevice');
INSERT INTO public.django_content_type (id, app_label, model) VALUES (12, 'otp_static', 'staticdevice');
INSERT INTO public.django_content_type (id, app_label, model) VALUES (13, 'otp_static', 'statictoken');
INSERT INTO public.django_content_type (id, app_label, model) VALUES (14, 'token_blacklist', 'blacklistedtoken');
INSERT INTO public.django_content_type (id, app_label, model) VALUES (15, 'token_blacklist', 'outstandingtoken');
INSERT INTO public.django_content_type (id, app_label, model) VALUES (16, 'enterprise', 'userguideuploads');
INSERT INTO public.django_content_type (id, app_label, model) VALUES (17, 'enterprise', 'userguidemodel');
INSERT INTO public.django_content_type (id, app_label, model) VALUES (18, 'analytics', 'analytics');
INSERT INTO public.django_content_type (id, app_label, model) VALUES (19, 'accounts', 'enterprise');
INSERT INTO public.django_content_type (id, app_label, model) VALUES (20, 'accounts', 'customer');
INSERT INTO public.django_content_type (id, app_label, model) VALUES (21, 'elroi_admin', 'adminenterpriseconfig');
INSERT INTO public.django_content_type (id, app_label, model) VALUES (22, 'accounts', 'customeruploads');
INSERT INTO public.django_content_type (id, app_label, model) VALUES (23, 'analytics', 'activitylog');


--
-- Data for Name: django_migrations; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.django_migrations (id, app, name, applied) VALUES (1, 'contenttypes', '0001_initial', '2020-10-20 14:41:29.844717+03');
INSERT INTO public.django_migrations (id, app, name, applied) VALUES (2, 'contenttypes', '0002_remove_content_type_name', '2020-10-20 14:41:29.864683+03');
INSERT INTO public.django_migrations (id, app, name, applied) VALUES (3, 'auth', '0001_initial', '2020-10-20 14:41:29.904011+03');
INSERT INTO public.django_migrations (id, app, name, applied) VALUES (4, 'auth', '0002_alter_permission_name_max_length', '2020-10-20 14:41:29.953452+03');
INSERT INTO public.django_migrations (id, app, name, applied) VALUES (5, 'auth', '0003_alter_user_email_max_length', '2020-10-20 14:41:29.958016+03');
INSERT INTO public.django_migrations (id, app, name, applied) VALUES (6, 'auth', '0004_alter_user_username_opts', '2020-10-20 14:41:29.963005+03');
INSERT INTO public.django_migrations (id, app, name, applied) VALUES (7, 'auth', '0005_alter_user_last_login_null', '2020-10-20 14:41:29.967992+03');
INSERT INTO public.django_migrations (id, app, name, applied) VALUES (8, 'auth', '0006_require_contenttypes_0002', '2020-10-20 14:41:29.970037+03');
INSERT INTO public.django_migrations (id, app, name, applied) VALUES (9, 'auth', '0007_alter_validators_add_error_messages', '2020-10-20 14:41:29.974028+03');
INSERT INTO public.django_migrations (id, app, name, applied) VALUES (10, 'auth', '0008_alter_user_username_max_length', '2020-10-20 14:41:29.979016+03');
INSERT INTO public.django_migrations (id, app, name, applied) VALUES (11, 'auth', '0009_alter_user_last_name_max_length', '2020-10-20 14:41:29.985057+03');
INSERT INTO public.django_migrations (id, app, name, applied) VALUES (12, 'auth', '0010_alter_group_name_max_length', '2020-10-20 14:41:30.001048+03');
INSERT INTO public.django_migrations (id, app, name, applied) VALUES (13, 'auth', '0011_update_proxy_permissions', '2020-10-20 14:41:30.006078+03');
INSERT INTO public.django_migrations (id, app, name, applied) VALUES (14, 'accounts', '0001_initial', '2020-10-20 14:41:30.053046+03');
INSERT INTO public.django_migrations (id, app, name, applied) VALUES (15, 'admin', '0001_initial', '2020-10-20 14:41:30.123964+03');
INSERT INTO public.django_migrations (id, app, name, applied) VALUES (16, 'admin', '0002_logentry_remove_auto_add', '2020-10-20 14:41:30.146962+03');
INSERT INTO public.django_migrations (id, app, name, applied) VALUES (17, 'admin', '0003_logentry_add_action_flag_choices', '2020-10-20 14:41:30.153971+03');
INSERT INTO public.django_migrations (id, app, name, applied) VALUES (18, 'consumer_request', '0001_initial', '2020-10-20 14:41:30.169085+03');
INSERT INTO public.django_migrations (id, app, name, applied) VALUES (19, 'consumer_request', '0002_consumerrequest_customer', '2020-10-20 14:41:30.179057+03');
INSERT INTO public.django_migrations (id, app, name, applied) VALUES (20, 'consumer_request', '0003_consumerrequest_enterprise', '2020-10-20 14:41:30.19475+03');
INSERT INTO public.django_migrations (id, app, name, applied) VALUES (21, 'enterprise', '0001_initial', '2020-10-20 14:41:30.217068+03');
INSERT INTO public.django_migrations (id, app, name, applied) VALUES (22, 'enterprise', '0002_customerconfiguration', '2020-10-20 14:41:30.240976+03');
INSERT INTO public.django_migrations (id, app, name, applied) VALUES (23, 'enterprise', '0003_enterpriseconfigurationmodel', '2020-10-20 14:41:30.268931+03');
INSERT INTO public.django_migrations (id, app, name, applied) VALUES (24, 'otp_static', '0001_initial', '2020-10-20 14:41:30.308834+03');
INSERT INTO public.django_migrations (id, app, name, applied) VALUES (25, 'otp_static', '0002_throttling', '2020-10-20 14:41:30.362904+03');
INSERT INTO public.django_migrations (id, app, name, applied) VALUES (26, 'otp_totp', '0001_initial', '2020-10-20 14:41:30.382899+03');
INSERT INTO public.django_migrations (id, app, name, applied) VALUES (27, 'otp_totp', '0002_auto_20190420_0723', '2020-10-20 14:41:30.412822+03');
INSERT INTO public.django_migrations (id, app, name, applied) VALUES (28, 'sessions', '0001_initial', '2020-10-20 14:41:30.428013+03');
INSERT INTO public.django_migrations (id, app, name, applied) VALUES (29, 'token_blacklist', '0001_initial', '2020-10-20 14:41:30.492554+03');
INSERT INTO public.django_migrations (id, app, name, applied) VALUES (30, 'token_blacklist', '0002_outstandingtoken_jti_hex', '2020-10-20 14:41:30.5145+03');
INSERT INTO public.django_migrations (id, app, name, applied) VALUES (31, 'token_blacklist', '0003_auto_20171017_2007', '2020-10-20 14:41:30.546414+03');
INSERT INTO public.django_migrations (id, app, name, applied) VALUES (32, 'token_blacklist', '0004_auto_20171017_2013', '2020-10-20 14:41:30.569349+03');
INSERT INTO public.django_migrations (id, app, name, applied) VALUES (33, 'token_blacklist', '0005_remove_outstandingtoken_jti', '2020-10-20 14:41:30.582372+03');
INSERT INTO public.django_migrations (id, app, name, applied) VALUES (34, 'token_blacklist', '0006_auto_20171017_2113', '2020-10-20 14:41:30.598272+03');
INSERT INTO public.django_migrations (id, app, name, applied) VALUES (35, 'token_blacklist', '0007_auto_20171017_2214', '2020-10-20 14:41:30.641156+03');
INSERT INTO public.django_migrations (id, app, name, applied) VALUES (36, 'accounts', '0002_auto_20201020_1445', '2020-10-20 14:46:02.970953+03');
INSERT INTO public.django_migrations (id, app, name, applied) VALUES (37, 'accounts', '0003_account_ce_id', '2020-10-21 15:25:58.093482+03');
INSERT INTO public.django_migrations (id, app, name, applied) VALUES (38, 'accounts', '0004_auto_20201021_2231', '2020-10-21 22:31:25.389432+03');
INSERT INTO public.django_migrations (id, app, name, applied) VALUES (39, 'enterprise', '0004_auto_20201021_2231', '2020-10-21 22:31:25.403217+03');
INSERT INTO public.django_migrations (id, app, name, applied) VALUES (40, 'accounts', '0005_auto_20201021_2232', '2020-10-21 22:33:05.768865+03');
INSERT INTO public.django_migrations (id, app, name, applied) VALUES (41, 'consumer_request', '0004_auto_20201023_1739', '2020-10-23 20:39:23.440308+03');
INSERT INTO public.django_migrations (id, app, name, applied) VALUES (42, 'enterprise', '0005_auto_20201023_1739', '2020-10-23 20:39:23.554124+03');
INSERT INTO public.django_migrations (id, app, name, applied) VALUES (44, 'enterprise', '0002_userguidemodel_owner', '2020-10-24 02:23:10.790447+03');
INSERT INTO public.django_migrations (id, app, name, applied) VALUES (46, 'accounts', '0006_auto_20201026_1225', '2020-10-26 14:25:59.450526+02');
INSERT INTO public.django_migrations (id, app, name, applied) VALUES (47, 'accounts', '0007_remove_customer_username', '2020-10-26 14:38:30.863589+02');
INSERT INTO public.django_migrations (id, app, name, applied) VALUES (48, 'accounts', '0008_auto_20201026_1408', '2020-10-26 16:08:34.761119+02');
INSERT INTO public.django_migrations (id, app, name, applied) VALUES (49, 'accounts', '0009_auto_20201026_1616', '2020-10-26 18:16:27.715162+02');
INSERT INTO public.django_migrations (id, app, name, applied) VALUES (50, 'accounts', '0010_auto_20201026_1617', '2020-10-26 18:17:56.930846+02');
INSERT INTO public.django_migrations (id, app, name, applied) VALUES (51, 'accounts', '0011_enterprise_email', '2020-10-26 18:20:08.774772+02');
INSERT INTO public.django_migrations (id, app, name, applied) VALUES (52, 'elroi_admin', '0001_initial', '2020-10-27 09:20:06.853037+02');
INSERT INTO public.django_migrations (id, app, name, applied) VALUES (53, 'accounts', '0012_auto_20201027_0826', '2020-10-27 10:26:23.740643+02');
INSERT INTO public.django_migrations (id, app, name, applied) VALUES (54, 'elroi_admin', '0002_auto_20201027_0826', '2020-10-27 10:26:23.788924+02');
INSERT INTO public.django_migrations (id, app, name, applied) VALUES (55, 'accounts', '0013_auto_20201027_1051', '2020-10-27 12:51:28.713737+02');
INSERT INTO public.django_migrations (id, app, name, applied) VALUES (57, 'accounts', '0014_customeruploads', '2020-10-27 15:09:27.54387+02');
INSERT INTO public.django_migrations (id, app, name, applied) VALUES (58, 'accounts', '0015_auto_20201027_1308', '2020-10-27 15:09:27.597057+02');
INSERT INTO public.django_migrations (id, app, name, applied) VALUES (59, 'accounts', '0014_customer_file', '2020-10-27 15:15:27.795198+02');
INSERT INTO public.django_migrations (id, app, name, applied) VALUES (60, 'consumer_request', '0005_auto_20201027_1727', '2020-10-27 19:29:44.373538+02');
INSERT INTO public.django_migrations (id, app, name, applied) VALUES (61, 'accounts', '0015_auto_20201029_1601', '2020-10-29 18:01:38.306559+02');
INSERT INTO public.django_migrations (id, app, name, applied) VALUES (62, 'consumer_request', '0006_auto_20201029_1743', '2020-10-29 19:44:05.274085+02');
INSERT INTO public.django_migrations (id, app, name, applied) VALUES (63, 'enterprise', '0003_auto_20201029_2213', '2020-10-30 00:13:42.841768+02');
INSERT INTO public.django_migrations (id, app, name, applied) VALUES (64, 'enterprise', '0004_auto_20201029_2247', '2020-10-30 00:47:35.042585+02');
INSERT INTO public.django_migrations (id, app, name, applied) VALUES (65, 'enterprise', '0005_auto_20201030_0028', '2020-10-30 02:28:10.766317+02');
INSERT INTO public.django_migrations (id, app, name, applied) VALUES (66, 'accounts', '0016_customeruploads', '2020-10-30 04:35:47.863067+02');
INSERT INTO public.django_migrations (id, app, name, applied) VALUES (67, 'accounts', '0017_auto_20201030_1501', '2020-10-30 17:01:36.355862+02');
INSERT INTO public.django_migrations (id, app, name, applied) VALUES (68, 'consumer_request', '0007_consumerrequest_request_form', '2020-10-30 17:01:36.373231+02');
INSERT INTO public.django_migrations (id, app, name, applied) VALUES (69, 'analytics', '0001_initial', '2020-10-31 12:21:04.924486+02');
INSERT INTO public.django_migrations (id, app, name, applied) VALUES (70, 'analytics', '0002_activitylog', '2020-10-31 12:25:01.649417+02');
INSERT INTO public.django_migrations (id, app, name, applied) VALUES (71, 'analytics', '0003_activitylog_elroi_id', '2020-11-01 00:56:46.884494+02');


--
-- Data for Name: django_session; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- Data for Name: enterprise_configuration; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.enterprise_configuration (id, title, additional_configuration, created_at, updated_at, enterprise_id, background_image, company_name, logo, resident_state, site_color, site_theme, website_launched_to) VALUES (1, 'Receiving data from customer', '{"allow_email": "true", "allow_api_call": "True"}', '2020-10-20 15:00:22.959279+03', '2020-10-20 15:00:22.959279+03', 2, '1', '1', '1', true, '1', '1', '1');
INSERT INTO public.enterprise_configuration (id, title, additional_configuration, created_at, updated_at, enterprise_id, background_image, company_name, logo, resident_state, site_color, site_theme, website_launched_to) VALUES (4, 'CCPA Request Form', '{"input": [{"name": "is_resident", "type": "radio", "label": "I am a state resident", "values": ["Yes", "No"]}, {"name": "first_name", "type": "text", "label": "First Name"}, {"name": "kyc", "type": "file", "label": "Upload your file"}]}', '2020-10-30 15:23:22.741775+02', '2020-10-30 15:23:22.741775+02', 8, '86479335_859506111128516_2570312921909297152_n_ofBow9q.jpg', 'Individual SRL', '87160790_859506167795177_3641859102793007104_n_RV9wNAG.jpg', false, '#f2f2f2', 'Site theme', 'https://google.com');


--
-- Data for Name: enterprise_customer_configuration; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- Data for Name: enterprises; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.enterprises (id, elroi_id, name, web, trial_start, trial_end, current_plan_end, created_at, user_id, email, is_active, updated_by_id, allow_api_call, allow_email_data, payment, turn_off_date) VALUES (1, 'E-A20D70', 'Individual SRL', NULL, NULL, NULL, NULL, '2020-10-26 18:20:25.414101+02', 33, 'enter@asda.om', true, NULL, true, true, '{"id": "paypal", "accessd": "adsfasdf"}', NULL);
INSERT INTO public.enterprises (id, elroi_id, name, web, trial_start, trial_end, current_plan_end, created_at, user_id, email, is_active, updated_by_id, allow_api_call, allow_email_data, payment, turn_off_date) VALUES (6, 'E-DBC517', 'Test Enterprise', NULL, NULL, NULL, NULL, '2020-10-27 19:48:07.968546+02', 43, 'enterprise@mail.com', true, NULL, true, true, NULL, NULL);
INSERT INTO public.enterprises (id, elroi_id, name, web, trial_start, trial_end, current_plan_end, created_at, user_id, email, is_active, updated_by_id, allow_api_call, allow_email_data, payment, turn_off_date) VALUES (7, 'E-C09D28', 'Test Enterprise', NULL, NULL, NULL, NULL, '2020-10-27 19:48:22.90606+02', 44, 'enterpr@mail.com', true, NULL, true, true, NULL, NULL);
INSERT INTO public.enterprises (id, elroi_id, name, web, trial_start, trial_end, current_plan_end, created_at, user_id, email, is_active, updated_by_id, allow_api_call, allow_email_data, payment, turn_off_date) VALUES (8, 'E-631FA6', 'Demo Enterprise', NULL, NULL, NULL, NULL, '2020-10-27 19:48:39.136307+02', 45, 'demo@mail.com', true, NULL, true, true, NULL, NULL);


--
-- Data for Name: otp_static_staticdevice; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- Data for Name: otp_static_statictoken; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- Data for Name: otp_totp_totpdevice; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- Data for Name: token_blacklist_blacklistedtoken; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- Data for Name: token_blacklist_outstandingtoken; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.token_blacklist_outstandingtoken (id, token, created_at, expires_at, user_id, jti) VALUES (1, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTYwMzI4MDc4MCwianRpIjoiOTFjOGI2MWUyZjY2NGMwYWJlNjhiMDJhODY3NTU0ODAiLCJ1c2VyX2lkIjoyfQ.zjmg1PqQ8QgZ9Ed0xznXacU9eU0nsa15UVujLBFXIec', '2020-10-20 14:46:20.909545+03', '2020-10-21 14:46:20+03', 2, '91c8b61e2f664c0abe68b02a86755480');
INSERT INTO public.token_blacklist_outstandingtoken (id, token, created_at, expires_at, user_id, jti) VALUES (2, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTYwMzI4MDc5MCwianRpIjoiMWI0OTViNDY0MjQ0NGI5MGI1ZjcwNjVlMjhmOGM4OTAiLCJ1c2VyX2lkIjoyfQ.1m9cvn-3NJsmWVmOdYOiECN2fndCnyleGnYk-08iUfM', '2020-10-20 14:46:30.690475+03', '2020-10-21 14:46:30+03', 2, '1b495b4642444b90b5f7065e28f8c890');
INSERT INTO public.token_blacklist_outstandingtoken (id, token, created_at, expires_at, user_id, jti) VALUES (3, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTYwMzI4MTU0MiwianRpIjoiZjQ4NmEwYTMxZTg0NDNmZTkzYWYwYWViN2M0YTM4MzEiLCJ1c2VyX2lkIjoyfQ.2VM_7cYktwJ5ZA_rNFDx1XzbMNYNQwai3Z7-dCr7DE8', '2020-10-20 14:59:02.282198+03', '2020-10-21 14:59:02+03', 2, 'f486a0a31e8443fe93af0aeb7c4a3831');
INSERT INTO public.token_blacklist_outstandingtoken (id, token, created_at, expires_at, user_id, jti) VALUES (4, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTYwMzM2NzkzMywianRpIjoiOWYyNjFkN2Q4NDQwNDAwNjk3MDljZjJjMTAwNjMyNzAiLCJ1c2VyX2lkIjoyfQ.CMgr_MYjHkkmn7NNbhRTPZbfIpdyEU54C2W8W1m9K1w', '2020-10-21 14:58:53.400738+03', '2020-10-22 14:58:53+03', 2, '9f261d7d844040069709cf2c10063270');
INSERT INTO public.token_blacklist_outstandingtoken (id, token, created_at, expires_at, user_id, jti) VALUES (5, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTYwMzM2Nzk0MiwianRpIjoiOGVhM2U3MjA3YWI0NDI0OGJmMjUyYWU4YmE3ZmVlOGEiLCJ1c2VyX2lkIjoyfQ.iREXiUijm0zSrrtQruDVU6XTkHzZMnQIiF841Am8_NM', '2020-10-21 14:59:02.893338+03', '2020-10-22 14:59:02+03', 2, '8ea3e7207ab44248bf252ae8ba7fee8a');
INSERT INTO public.token_blacklist_outstandingtoken (id, token, created_at, expires_at, user_id, jti) VALUES (6, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTYwMzM2ODAzNSwianRpIjoiMGUyY2U1NmM0Mjg0NDY4ZWIzZDU5ZmJiNzEzZWZkNDAiLCJ1c2VyX2lkIjoyfQ.ebX-zhgZ9L7nlM2H5qyumqH0i8aNz8CN5RFthr6M814', '2020-10-21 15:00:35.893138+03', '2020-10-22 15:00:35+03', 2, '0e2ce56c4284468eb3d59fbb713efd40');
INSERT INTO public.token_blacklist_outstandingtoken (id, token, created_at, expires_at, user_id, jti) VALUES (7, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTYwMzM2ODAzOCwianRpIjoiMTcyMWNjNDJmYjA3NDk3NWEyOTUyM2JiZGY2ZDA2MGUiLCJ1c2VyX2lkIjoyfQ.OS3zefrh5AffG8WaxsTif06NkvmTiwXSK-YyC7Lyz8k', '2020-10-21 15:00:38.443521+03', '2020-10-22 15:00:38+03', 2, '1721cc42fb074975a29523bbdf6d060e');
INSERT INTO public.token_blacklist_outstandingtoken (id, token, created_at, expires_at, user_id, jti) VALUES (8, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTYwMzM2ODA4MSwianRpIjoiYTMxMzFjMGJkNDJjNDBmMWJmYmNlMzg4ZmQ3NThkMjMiLCJ1c2VyX2lkIjoyfQ.hejSNjkvalmYtmUJRGzECdDLgBFwmCs3nCz4DTqn30A', '2020-10-21 15:01:21.095943+03', '2020-10-22 15:01:21+03', 2, 'a3131c0bd42c40f1bfbce388fd758d23');
INSERT INTO public.token_blacklist_outstandingtoken (id, token, created_at, expires_at, user_id, jti) VALUES (9, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTYwMzM2ODEwNywianRpIjoiY2NlMWE2MGI3MWY4NGJiYzhkMDI2NDlhODU0ZTgzZDciLCJ1c2VyX2lkIjoyfQ.yAiRFpqw8bN28-SGqR2MxjOUER27fD2oXbD7C1ropWI', '2020-10-21 15:01:47.605557+03', '2020-10-22 15:01:47+03', 2, 'cce1a60b71f84bbc8d02649a854e83d7');
INSERT INTO public.token_blacklist_outstandingtoken (id, token, created_at, expires_at, user_id, jti) VALUES (10, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTYwMzM2ODI0NywianRpIjoiMTQ2M2M1MzM1ZTQzNDIwYWIwZWUwMDg3NGZmYzNjYzAiLCJ1c2VyX2lkIjoyfQ.fMffUDA0FFdy0-fQRB-UKztKM464Ws3kqSLI4YYebEk', '2020-10-21 15:04:07.734812+03', '2020-10-22 15:04:07+03', 2, '1463c5335e43420ab0ee00874ffc3cc0');
INSERT INTO public.token_blacklist_outstandingtoken (id, token, created_at, expires_at, user_id, jti) VALUES (11, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTYwMzM2OTQ5MCwianRpIjoiOGE2NmUxZGNmMGQ5NGM3ODlmZmE0YmRiOGE0ZGRjMzAiLCJ1c2VyX2lkIjoyfQ.xgev4ouEu7ON-a26nk3M4IO6-vWoULOD8N_o6wvZ1g8', '2020-10-21 15:24:50.877408+03', '2020-10-22 15:24:50+03', 2, '8a66e1dcf0d94c789ffa4bdb8a4ddc30');
INSERT INTO public.token_blacklist_outstandingtoken (id, token, created_at, expires_at, user_id, jti) VALUES (12, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTYwMzM3MzQ2NCwianRpIjoiMGJiNzQ1YzJkMzA0NDQyYmJiNmY2YzVmNTc2YTFkMDIiLCJ1c2VyX2lkIjoyfQ.Pw4T3TnN-tV1BGOFZFbYnH5Ghr2tuL6sp2eddsED3YA', '2020-10-21 16:31:04.743862+03', '2020-10-22 16:31:04+03', 2, '0bb745c2d304442bbb6f6c5f576a1d02');
INSERT INTO public.token_blacklist_outstandingtoken (id, token, created_at, expires_at, user_id, jti) VALUES (13, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTYwMzM3MzUxNywianRpIjoiOGYzMWJmMDRmYmNkNDdmYjgwNTNjNTFlMWJiM2ZkZTMiLCJ1c2VyX2lkIjoyfQ.vdATR4B31IiGGb4jgPcj2V2j4XYKSgg3UFAm1zQ55tk', '2020-10-21 16:31:57.405426+03', '2020-10-22 16:31:57+03', 2, '8f31bf04fbcd47fb8053c51e1bb3fde3');
INSERT INTO public.token_blacklist_outstandingtoken (id, token, created_at, expires_at, user_id, jti) VALUES (14, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTYwMzM3MzY5NywianRpIjoiZDBjYjEzZTc1YzA5NGM4ZjgzOTQ0NTQ4ZDJjNDEwYzkiLCJ1c2VyX2lkIjoyfQ.zWMsjqT4xm9zqwAeydA7jHTCnc0wDAD8RwUSIAH6J4Q', '2020-10-21 16:34:57.36162+03', '2020-10-22 16:34:57+03', 2, 'd0cb13e75c094c8f83944548d2c410c9');
INSERT INTO public.token_blacklist_outstandingtoken (id, token, created_at, expires_at, user_id, jti) VALUES (15, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTYwMzM3MzcxMCwianRpIjoiY2U1NDg4NzliNzU4NDIyODlmYjY1MTc3MTFlZDQzYzYiLCJ1c2VyX2lkIjoyfQ.DdlsX1R2x84S8qUnlVOnaYGIuGhw9YrRtM4tNlP4QkA', '2020-10-21 16:35:10.065195+03', '2020-10-22 16:35:10+03', 2, 'ce548879b75842289fb6517711ed43c6');
INSERT INTO public.token_blacklist_outstandingtoken (id, token, created_at, expires_at, user_id, jti) VALUES (16, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTYwMzM3Mzc1OSwianRpIjoiZjRhMmFjYTkxYTlkNGE5ZmFmMzg2OGE3NTg5ODgzZWMiLCJ1c2VyX2lkIjoyfQ.em1TA9rMTj6cqwDpPRU-sCPEPU2okSDRjg15NO-pdxk', '2020-10-21 16:35:59.937277+03', '2020-10-22 16:35:59+03', 2, 'f4a2aca91a9d4a9faf3868a7589883ec');
INSERT INTO public.token_blacklist_outstandingtoken (id, token, created_at, expires_at, user_id, jti) VALUES (17, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTYwMzM3Mzc5MCwianRpIjoiODc1ODZjYTJlMTY3NGUyOGFhMDczNDUwODA4MTc0ZmYiLCJ1c2VyX2lkIjoyfQ.NYO3jGwiK0bnyaFbbQE71rZAvZm2Z4PbCCkRWCYgdrc', '2020-10-21 16:36:30.366782+03', '2020-10-22 16:36:30+03', 2, '87586ca2e1674e28aa073450808174ff');
INSERT INTO public.token_blacklist_outstandingtoken (id, token, created_at, expires_at, user_id, jti) VALUES (18, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTYwMzM3MzgxNiwianRpIjoiMGMyY2NjZTQ2Yzk1NDRkZDgwNWViNjRhN2Y0MDE5ZmQiLCJ1c2VyX2lkIjoyfQ.h07Hnh2800_IVemMpiJYu2sWJOOnd1lM45ew8Hhxi2A', '2020-10-21 16:36:56.32034+03', '2020-10-22 16:36:56+03', 2, '0c2ccce46c9544dd805eb64a7f4019fd');
INSERT INTO public.token_blacklist_outstandingtoken (id, token, created_at, expires_at, user_id, jti) VALUES (19, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTYwMzM3MzgzMSwianRpIjoiNDIwMTIzOTRhYzJjNGY4Nzk3MjNiZGJhODU1OGRhZDQiLCJ1c2VyX2lkIjoyfQ.AFLrnIjh8GygkY9vs49X45D-4uO6s8fARI1OAnv2GvM', '2020-10-21 16:37:11.476939+03', '2020-10-22 16:37:11+03', 2, '42012394ac2c4f879723bdba8558dad4');
INSERT INTO public.token_blacklist_outstandingtoken (id, token, created_at, expires_at, user_id, jti) VALUES (20, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTYwMzM3Mzg2NiwianRpIjoiZGU0MDgxYTcyODliNGVhYmIzZjBjOGY5YjYwNmNmNTYiLCJ1c2VyX2lkIjoyfQ.-xi543UnuQ4QNsU-P_TtqDqTJOnoUxMMcEBWgZ8wDYM', '2020-10-21 16:37:46.846359+03', '2020-10-22 16:37:46+03', 2, 'de4081a7289b4eabb3f0c8f9b606cf56');
INSERT INTO public.token_blacklist_outstandingtoken (id, token, created_at, expires_at, user_id, jti) VALUES (21, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTYwMzM3Mzg4OCwianRpIjoiMjQxNTM0YjNlMzU0NDU2YzkyNDhlZTFiYWE0YjVkNjkiLCJ1c2VyX2lkIjoyfQ.nUxcYrufr4Qs_B_tY6mvteh8kSYfTeADLOFPIaJ83ug', '2020-10-21 16:38:08.550336+03', '2020-10-22 16:38:08+03', 2, '241534b3e354456c9248ee1baa4b5d69');
INSERT INTO public.token_blacklist_outstandingtoken (id, token, created_at, expires_at, user_id, jti) VALUES (22, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTYwMzM3NjUxOCwianRpIjoiZGJjZGE2ZTU0NmU4NGIzY2FhNjEzYjVjNjI1NzBlOTgiLCJ1c2VyX2lkIjoyfQ.nbXGSMMVnJmTzNxxvktOUNlrOBKBumk6YSDTWlnZwtg', '2020-10-21 17:21:58.844315+03', '2020-10-22 17:21:58+03', 2, 'dbcda6e546e84b3caa613b5c62570e98');
INSERT INTO public.token_blacklist_outstandingtoken (id, token, created_at, expires_at, user_id, jti) VALUES (23, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTYwMzM5NTIwOSwianRpIjoiZGNhYTc5MGQ2MDA5NDgyNzg3ODgwNGZmOTFmNTljMTQiLCJ1c2VyX2lkIjozfQ.onI4v_tQVMz6yd5TZLp03S4lzof2Bej4huYarjEYx4s', '2020-10-21 22:33:29.94854+03', '2020-10-22 22:33:29+03', 3, 'dcaa790d60094827878804ff91f59c14');
INSERT INTO public.token_blacklist_outstandingtoken (id, token, created_at, expires_at, user_id, jti) VALUES (24, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTYwMzM5NTIxMSwianRpIjoiYmFkMWQyY2MwNTczNDRkYWJhN2VkNTFjZTQ0OWJiYWYiLCJ1c2VyX2lkIjozfQ.PYXlKwTTj5DMj0Pb8B-OpUTw_HJmlaLEQ6jSAdvldw0', '2020-10-21 22:33:31.537756+03', '2020-10-22 22:33:31+03', 3, 'bad1d2cc057344daba7ed51ce449bbaf');
INSERT INTO public.token_blacklist_outstandingtoken (id, token, created_at, expires_at, user_id, jti) VALUES (25, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTYwMzM5NTI5NSwianRpIjoiN2E3NjQzODg3NjNiNGFjNTgzMDZiNDllZjRiMTE1NmEiLCJ1c2VyX2lkIjo0fQ.3kT1C9RqGlLdWisB67yXMCdG--TUYPSjBh1lULe4O6s', '2020-10-21 22:34:55.745604+03', '2020-10-22 22:34:55+03', 4, '7a764388763b4ac58306b49ef4b1156a');
INSERT INTO public.token_blacklist_outstandingtoken (id, token, created_at, expires_at, user_id, jti) VALUES (26, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTYwMzM5NTUyOCwianRpIjoiNzczY2YwNDgwODIwNDVjNGI1NzE0MDJjN2FjNDEzNzAiLCJ1c2VyX2lkIjo1fQ.dHXXZ6q4HemsZc3lMskoJlq-8IOZtR-zMVNdQMVBcYo', '2020-10-21 22:38:48.05479+03', '2020-10-22 22:38:48+03', 5, '773cf048082045c4b571402c7ac41370');
INSERT INTO public.token_blacklist_outstandingtoken (id, token, created_at, expires_at, user_id, jti) VALUES (27, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTYwMzM5NTUyOCwianRpIjoiODJmNTQ3NDFhM2NkNDdmODkxMjQzMmQ3NDdjMWNkMjIiLCJ1c2VyX2lkIjo1fQ.wSgoGw6ZsTZh2a-mqIhh1zBNV11fmTIak5yVOZURYh8', '2020-10-21 22:38:48.058614+03', '2020-10-22 22:38:48+03', 5, '82f54741a3cd47f8912432d747c1cd22');
INSERT INTO public.token_blacklist_outstandingtoken (id, token, created_at, expires_at, user_id, jti) VALUES (28, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTYwMzM5NTUyOSwianRpIjoiMWVlZTFhODU1ZTRkNGVlMzgzNjA4ZmE4MjUxZTUxNWIiLCJ1c2VyX2lkIjo1fQ.lqnZq04It1-WEwIaDfHKkyTtZnyyBjSGJThbhoQzmzQ', '2020-10-21 22:38:49.457461+03', '2020-10-22 22:38:49+03', 5, '1eee1a855e4d4ee383608fa8251e515b');
INSERT INTO public.token_blacklist_outstandingtoken (id, token, created_at, expires_at, user_id, jti) VALUES (29, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTYwMzM5NTY0MCwianRpIjoiNzFhZDQ5MDRjMzY5NDcwYjg0NmI3YjJhODM1OWM5NWIiLCJ1c2VyX2lkIjo2fQ.5VNi_q6CBu8nSHSdxmPyEWRr0TOpZlvvkgGeUfZ8Se4', '2020-10-21 22:40:40.590633+03', '2020-10-22 22:40:40+03', 6, '71ad4904c369470b846b7b2a8359c95b');
INSERT INTO public.token_blacklist_outstandingtoken (id, token, created_at, expires_at, user_id, jti) VALUES (30, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTYwMzM5NTY0MCwianRpIjoiYWU4MDcwNzhhYTc3NGM0ZTg2MjA2YmRkZWJlMDA2ODgiLCJ1c2VyX2lkIjo2fQ.8gmylF3Cjlq05kBvuubWwDDzO4WBmBIE-z5TXMmiOuo', '2020-10-21 22:40:40.595622+03', '2020-10-22 22:40:40+03', 6, 'ae807078aa774c4e86206bddebe00688');
INSERT INTO public.token_blacklist_outstandingtoken (id, token, created_at, expires_at, user_id, jti) VALUES (31, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTYwMzM5NTY0MiwianRpIjoiOTA3YzliNmZhZGQwNDU2OGEyNzQyN2M0N2NhNTMwNjUiLCJ1c2VyX2lkIjo2fQ.fhsN4kB0mAKDE_oFes1AYMQlqZRDwUG-tDo2Vb6uTvw', '2020-10-21 22:40:42.139529+03', '2020-10-22 22:40:42+03', 6, '907c9b6fadd04568a27427c47ca53065');
INSERT INTO public.token_blacklist_outstandingtoken (id, token, created_at, expires_at, user_id, jti) VALUES (32, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTYwMzM5NTc0MCwianRpIjoiZjFkZGM0Y2NjZWE5NDZjOGEzNmI4ZDVmYzRiNjY0YTYiLCJ1c2VyX2lkIjo3fQ.QvTnJurEKhfagB3RbDSwnSkBW-S1FEXWJHmFYkVtOaQ', '2020-10-21 22:42:20.535116+03', '2020-10-22 22:42:20+03', 7, 'f1ddc4cccea946c8a36b8d5fc4b664a6');
INSERT INTO public.token_blacklist_outstandingtoken (id, token, created_at, expires_at, user_id, jti) VALUES (33, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTYwMzM5NTc0MCwianRpIjoiMGQzZjUyYTU2MGZhNGUwODhlYTI0MzJmMThkYzY3ZDciLCJ1c2VyX2lkIjo3fQ.vi-MGVxlyfXhoHS9m5ANqRCFZHZjUR8EW4sVsJH2XPM', '2020-10-21 22:42:20.539105+03', '2020-10-22 22:42:20+03', 7, '0d3f52a560fa4e088ea2432f18dc67d7');
INSERT INTO public.token_blacklist_outstandingtoken (id, token, created_at, expires_at, user_id, jti) VALUES (34, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTYwMzM5NTc0MiwianRpIjoiMTg0OGUwNGFmZmNkNGVmNGJhMWZjNWNjNzUxZjMzNzUiLCJ1c2VyX2lkIjo3fQ.nqRdyoHXVsgVlCdYlgW3qKXZ_nZAkT9VrgDIzCEfNVY', '2020-10-21 22:42:22.019403+03', '2020-10-22 22:42:22+03', 7, '1848e04affcd4ef4ba1fc5cc751f3375');
INSERT INTO public.token_blacklist_outstandingtoken (id, token, created_at, expires_at, user_id, jti) VALUES (35, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTYwMzM5NTg4NiwianRpIjoiYzkzMjUyMTU1OWI5NGFiZmEyYWMyZjA2ODg0M2Y3ODEiLCJ1c2VyX2lkIjo4fQ.vrS5Cn7mOhj9ynDhbPAAxp_AUTdHr9_f8z950TWQqaM', '2020-10-21 22:44:46.598506+03', '2020-10-22 22:44:46+03', 8, 'c932521559b94abfa2ac2f068843f781');
INSERT INTO public.token_blacklist_outstandingtoken (id, token, created_at, expires_at, user_id, jti) VALUES (36, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTYwMzM5NTg4NiwianRpIjoiY2I0OGJlZmQxZTZmNDFlZTkyM2ViOWRkMTAwNTA2MWIiLCJ1c2VyX2lkIjo4fQ.Neb1Z0ianQ-yO3M0ddevJ0Yk1VXcPsnID-iUrf7OZag', '2020-10-21 22:44:46.601529+03', '2020-10-22 22:44:46+03', 8, 'cb48befd1e6f41ee923eb9dd1005061b');
INSERT INTO public.token_blacklist_outstandingtoken (id, token, created_at, expires_at, user_id, jti) VALUES (37, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTYwMzM5NTg4OCwianRpIjoiNmMxNzE1YTkxMjZjNDk5MWE5OTY2Mzg2ZjUzMTM1MzIiLCJ1c2VyX2lkIjo4fQ.fsxCDMYJEEGidrtCoIbhMv6t1__OCZkVkWll6dECehY', '2020-10-21 22:44:48.031215+03', '2020-10-22 22:44:48+03', 8, '6c1715a9126c4991a9966386f5313532');
INSERT INTO public.token_blacklist_outstandingtoken (id, token, created_at, expires_at, user_id, jti) VALUES (38, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTYwMzM5NjE3MCwianRpIjoiZjZiZTEwN2QxOWRlNDg0ODk5YmZjYzVmMGVkZDllZTYiLCJ1c2VyX2lkIjo5fQ.zTm8kfoyn0_Qd9HfbvjXiYJNgBmXp0FcoIlj_n4ZTpM', '2020-10-21 22:49:30.26756+03', '2020-10-22 22:49:30+03', 9, 'f6be107d19de484899bfcc5f0edd9ee6');
INSERT INTO public.token_blacklist_outstandingtoken (id, token, created_at, expires_at, user_id, jti) VALUES (39, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTYwMzM5NjE3MCwianRpIjoiN2EwOTM0ZDZjMzIzNGFiM2FmMWE4MjBmYzQ3OGRjZDAiLCJ1c2VyX2lkIjo5fQ.uDLGpkmO7vvfMYd230eSlArfSQlAHHIl51DcSliYifs', '2020-10-21 22:49:30.271549+03', '2020-10-22 22:49:30+03', 9, '7a0934d6c3234ab3af1a820fc478dcd0');
INSERT INTO public.token_blacklist_outstandingtoken (id, token, created_at, expires_at, user_id, jti) VALUES (40, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTYwMzM5NjE3MSwianRpIjoiOTNiZjIwMzlmNzQ2NGY0NmExNjk0M2UwZTcwZGM3NDQiLCJ1c2VyX2lkIjo5fQ.gbfRayzh0_tnTDtzA_AFl683TK3piFsPttYzMnm8ZZk', '2020-10-21 22:49:31.689471+03', '2020-10-22 22:49:31+03', 9, '93bf2039f7464f46a16943e0e70dc744');
INSERT INTO public.token_blacklist_outstandingtoken (id, token, created_at, expires_at, user_id, jti) VALUES (41, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTYwMzQ1NzM2NywianRpIjoiNjI3ZWFhMTAwNTNhNDNlMDgzZjJmYmJkOTAxZjUyODMiLCJ1c2VyX2lkIjoyfQ.sfrucHfhLiXvdzYH7ipp3VONDkDZnKt25DRnBwNbm9g', '2020-10-22 15:49:27.587692+03', '2020-10-23 15:49:27+03', 2, '627eaa10053a43e083f2fbbd901f5283');
INSERT INTO public.token_blacklist_outstandingtoken (id, token, created_at, expires_at, user_id, jti) VALUES (42, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTYwMzUyOTk1MSwianRpIjoiZGMyYzY1NDYyZmFmNDNlNGE1NWIwOGY3MmMyYmEwZGEiLCJ1c2VyX2lkIjoyfQ.pz_JkBnLtVO5d1_VgZ9r9PHqJjR59_OYOtQYw-PeXmc', '2020-10-23 11:59:11.547518+03', '2020-10-24 11:59:11+03', 2, 'dc2c65462faf43e4a55b08f72c2ba0da');
INSERT INTO public.token_blacklist_outstandingtoken (id, token, created_at, expires_at, user_id, jti) VALUES (43, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTYwMzUzMDM3NiwianRpIjoiNDMwZmQ2YzRmZDIwNDEzYWJiM2RjOTNlMDFjYjY0MDgiLCJ1c2VyX2lkIjoyfQ.cs7-fFjXzGl3RaE4ibBput_Lx5PKEsP2KnrtrkmnyqM', '2020-10-23 12:06:16.760205+03', '2020-10-24 12:06:16+03', 2, '430fd6c4fd20413abb3dc93e01cb6408');
INSERT INTO public.token_blacklist_outstandingtoken (id, token, created_at, expires_at, user_id, jti) VALUES (44, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTYwMzU1MDQwMiwianRpIjoiMGUzNDYzMjkxYjAwNDY5ZTk2MmQ5YjMwNzQ2NzkwZjYiLCJ1c2VyX2lkIjoyfQ.322KQXux3i0a-fQyXN-_4wNSR96yeDbXiIpcFrJY9Es', '2020-10-23 17:40:02.173858+03', '2020-10-24 17:40:02+03', 2, '0e3463291b00469e962d9b30746790f6');
INSERT INTO public.token_blacklist_outstandingtoken (id, token, created_at, expires_at, user_id, jti) VALUES (45, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTYwMzU2ODgwMywianRpIjoiMjFlNjQ2YzQxMjc3NGI4N2IwZDMwMzgyMzcwNmZlM2YiLCJ1c2VyX2lkIjoyfQ.c8QhZEIkramefDsezIPSCpJ3_WoGCYE2bZ6Z-pYFKQg', '2020-10-23 22:46:43.863255+03', '2020-10-24 22:46:43+03', 2, '21e646c412774b87b0d303823706fe3f');
INSERT INTO public.token_blacklist_outstandingtoken (id, token, created_at, expires_at, user_id, jti) VALUES (46, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTYwMzU3MTQzNywianRpIjoiZDMzNDY4Y2M1YTQwNDExN2FjZGIxMmRkZDdmNWZhODciLCJ1c2VyX2lkIjoyfQ.nzuUyesZNufEmxZpknMvflX9htZof6UjbcvwG9jP6Uw', '2020-10-23 23:30:37.417981+03', '2020-10-24 23:30:37+03', 2, 'd33468cc5a404117acdb12ddd7f5fa87');
INSERT INTO public.token_blacklist_outstandingtoken (id, token, created_at, expires_at, user_id, jti) VALUES (47, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTYwMzU3OTQyNCwianRpIjoiNzA3Y2M4ZmNkMGZlNDJlYzk3YWFiYzE5MWY5N2QzMmEiLCJ1c2VyX2lkIjoyfQ.PY3ltETal8fE4qERFIrfhlmXJFhUKHFci8W8IMXRpQc', '2020-10-24 01:43:44.17872+03', '2020-10-25 01:43:44+03', 2, '707cc8fcd0fe42ec97aabc191f97d32a');
INSERT INTO public.token_blacklist_outstandingtoken (id, token, created_at, expires_at, user_id, jti) VALUES (48, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTYwMzU4MTQyMiwianRpIjoiZmE0N2U5YzBiZDc5NDQ3YWJhNzFkM2EyZDk3M2M2ODkiLCJ1c2VyX2lkIjoxMH0.3gxSDlzGbtLZZHopk3tmFUe68ftLo7z8GfqPO_s9rWE', '2020-10-24 02:17:02.519233+03', '2020-10-25 02:17:02+03', 10, 'fa47e9c0bd79447aba71d3a2d973c689');
INSERT INTO public.token_blacklist_outstandingtoken (id, token, created_at, expires_at, user_id, jti) VALUES (49, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTYwMzU4MTQyMiwianRpIjoiNTdmMmYxYWRiYTQ0NDFjNTkxMTRhOThlNzFkMzIxYTMiLCJ1c2VyX2lkIjoxMH0.f-rNM6Yj4RLy-VbkL9piM1LpZC_7VAbgQ0GO4Oq_Ghc', '2020-10-24 02:17:02.522952+03', '2020-10-25 02:17:02+03', 10, '57f2f1adba4441c59114a98e71d321a3');
INSERT INTO public.token_blacklist_outstandingtoken (id, token, created_at, expires_at, user_id, jti) VALUES (50, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTYwMzU4MTQyNCwianRpIjoiYmU4NTgwMjQwZjY4NGJiY2JiMGU1ZGVkZjNlMzRjYjEiLCJ1c2VyX2lkIjoxMH0.1xTud2TBUSQb1W7gB0I-J6oJOnAk5bz7tNwwSlcb54I', '2020-10-24 02:17:04.086615+03', '2020-10-25 02:17:04+03', 10, 'be8580240f684bbcbb0e5dedf3e34cb1');
INSERT INTO public.token_blacklist_outstandingtoken (id, token, created_at, expires_at, user_id, jti) VALUES (51, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTYwMzc5OTE0MiwianRpIjoiOTNkMzM2MTFhM2I3NDUzZmE3ZWI2MDMxMzE1NjMzNTkiLCJ1c2VyX2lkIjoxMX0.fp9S44t-yqxhBxisMmNlkLjl-gelp4h-FX3S-ebdAWk', '2020-10-26 13:45:42.156107+02', '2020-10-27 13:45:42+02', 11, '93d33611a3b7453fa7eb603131563359');
INSERT INTO public.token_blacklist_outstandingtoken (id, token, created_at, expires_at, user_id, jti) VALUES (52, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTYwMzc5OTE0MywianRpIjoiYjc1ZmMxMDJmZjI3NDUzZDkyNWQyZGU5ODk1YzE4MTUiLCJ1c2VyX2lkIjoxMX0.fmiZIUAQgHWdd_Mg9uSwvCHYNEoZ_Q3blqe_B85PZII', '2020-10-26 13:45:43.739576+02', '2020-10-27 13:45:43+02', 11, 'b75fc102ff27453d925d2de9895c1815');
INSERT INTO public.token_blacklist_outstandingtoken (id, token, created_at, expires_at, user_id, jti) VALUES (53, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTYwMzc5OTg5OSwianRpIjoiMzgxYWEyNjYyOTRkNGI0NmIwNWMwZTRjZGUzZDU5MjQiLCJ1c2VyX2lkIjoxN30.B1nFkX1UUI_x3uJOw8OGmbwwcE5JN9I6eD_a8AXqq9c', '2020-10-26 13:58:19.087586+02', '2020-10-27 13:58:19+02', 17, '381aa266294d4b46b05c0e4cde3d5924');
INSERT INTO public.token_blacklist_outstandingtoken (id, token, created_at, expires_at, user_id, jti) VALUES (54, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTYwMzc5OTkwMCwianRpIjoiNDc1Yjk0ZDgxMTExNDNkZThmNTMwODBlOTMxNTIyY2MiLCJ1c2VyX2lkIjoxN30.b3x7lbRARshrnXdxqj3zeHlPjmaCgjK7M9-xzRYxkUM', '2020-10-26 13:58:20.601518+02', '2020-10-27 13:58:20+02', 17, '475b94d8111143de8f53080e931522cc');
INSERT INTO public.token_blacklist_outstandingtoken (id, token, created_at, expires_at, user_id, jti) VALUES (55, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTYwMzgwMTAwNiwianRpIjoiZGNmMmQ2ZWEzOGU2NGU1OTkzNTEzNjhmYWQ0Y2M0NTQiLCJ1c2VyX2lkIjoyOH0.fynezLTJ21BjghkfWox8d4xD6D2Cy010dfw7Xb-Oy78', '2020-10-26 14:16:46.407915+02', '2020-10-27 14:16:46+02', 28, 'dcf2d6ea38e64e599351368fad4cc454');
INSERT INTO public.token_blacklist_outstandingtoken (id, token, created_at, expires_at, user_id, jti) VALUES (56, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTYwMzgwMTA2MywianRpIjoiMjEyMjZhN2Y2NWM3NDA5ODlmOWVhNGZhOGJlZmQ3MjIiLCJ1c2VyX2lkIjoyOX0.HhRRzV-yoyZUj67YyZqcFULwlP7tkIAJm142o1yNC4E', '2020-10-26 14:17:43.716173+02', '2020-10-27 14:17:43+02', 29, '21226a7f65c740989f9ea4fa8befd722');
INSERT INTO public.token_blacklist_outstandingtoken (id, token, created_at, expires_at, user_id, jti) VALUES (57, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTYwMzgwMTA2NSwianRpIjoiZDg3YzEzNDQ0YjViNGNiZGIxYjUzNTRiMjEwNjlhNDAiLCJ1c2VyX2lkIjoyOX0.ruEttwgIFcQrh27ST-prXxiRsdACnj1inF8mA2VDEJ8', '2020-10-26 14:17:45.143465+02', '2020-10-27 14:17:45+02', 29, 'd87c13444b5b4cbdb1b5354b21069a40');
INSERT INTO public.token_blacklist_outstandingtoken (id, token, created_at, expires_at, user_id, jti) VALUES (58, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTYwMzgwMTMyMSwianRpIjoiN2QzYmJjZjQwMGQyNDgxYzk3NzNhZjQ3OTAwMTViYWEiLCJ1c2VyX2lkIjozMX0.rOlWdVRQgKhTTmEvxiHn8EUL2932t61MuVgw8dYIc6E', '2020-10-26 14:22:01.827467+02', '2020-10-27 14:22:01+02', 31, '7d3bbcf400d2481c9773af4790015baa');
INSERT INTO public.token_blacklist_outstandingtoken (id, token, created_at, expires_at, user_id, jti) VALUES (59, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTYwMzgwMTMyMywianRpIjoiM2E2M2VjMTRjYzkyNDBhNmI0NGExM2Q2NDIxZmI4NWEiLCJ1c2VyX2lkIjozMX0.bhqRXbNDjGqT2ba75swis-vS6uCcT65la-OqHZ2Gd1M', '2020-10-26 14:22:03.300504+02', '2020-10-27 14:22:03+02', 31, '3a63ec14cc9240a6b44a13d6421fb85a');
INSERT INTO public.token_blacklist_outstandingtoken (id, token, created_at, expires_at, user_id, jti) VALUES (60, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTYwMzgwODQyNSwianRpIjoiZGI3YzlhZDBjMDY3NGIwNjgxYzYxY2YzYjNkYTBkM2UiLCJ1c2VyX2lkIjozM30.xzorqGnwI-wrQgD5jgz1w_Hy3vWTU2HNMNzA85-JaWo', '2020-10-26 16:20:25.425019+02', '2020-10-27 16:20:25+02', 33, 'db7c9ad0c0674b0681c61cf3b3da0d3e');
INSERT INTO public.token_blacklist_outstandingtoken (id, token, created_at, expires_at, user_id, jti) VALUES (61, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTYwMzgwODQyNiwianRpIjoiYmZkOTkzOGU3MWMxNGE0MmI1MDdlOGU3YmExN2Y4Y2IiLCJ1c2VyX2lkIjozM30.VZZZc6jpV2uhmfuFDd28zxiznYxKCALOrSeXCHhFy6Y', '2020-10-26 16:20:26.879741+02', '2020-10-27 16:20:26+02', 33, 'bfd9938e71c14a42b507e8e7ba17f8cb');
INSERT INTO public.token_blacklist_outstandingtoken (id, token, created_at, expires_at, user_id, jti) VALUES (62, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTYwMzgwOTkzNCwianRpIjoiYzQ0YzFkZjJjMWMwNGYyZGEwYjc5M2I1ODM1YTMyNDciLCJ1c2VyX2lkIjozM30.L4Aty4aD5x_o-fGget0TuiN6w2PibnXxO62MEGf8Wp0', '2020-10-26 16:45:34.099975+02', '2020-10-27 16:45:34+02', 33, 'c44c1df2c1c04f2da0b793b5835a3247');
INSERT INTO public.token_blacklist_outstandingtoken (id, token, created_at, expires_at, user_id, jti) VALUES (63, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTYwMzgxMDEyMiwianRpIjoiMTI5MmQ4MTY2NGViNGU4ODk4MWM2ZjE4MmQ3ZDU5YjUiLCJ1c2VyX2lkIjozM30.C2Fdz_5euK_ta9KZ_8fmBtfx0L-JvuXJWsMr_ENzTlk', '2020-10-26 16:48:42.458379+02', '2020-10-27 16:48:42+02', 33, '1292d81664eb4e88981c6f182d7d59b5');
INSERT INTO public.token_blacklist_outstandingtoken (id, token, created_at, expires_at, user_id, jti) VALUES (64, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTYwMzgxMDI2NSwianRpIjoiOGYxMjZiMDdkOTNjNDE4OWE2MjFjODg1ZWRlZDRiOTgiLCJ1c2VyX2lkIjozM30.14lt9DxuWcy1e6qiQCz85OPHTPVEo9RI22Asa-VZRgo', '2020-10-26 16:51:05.382145+02', '2020-10-27 16:51:05+02', 33, '8f126b07d93c4189a621c885eded4b98');
INSERT INTO public.token_blacklist_outstandingtoken (id, token, created_at, expires_at, user_id, jti) VALUES (65, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTYwMzgxMDQwNywianRpIjoiZDQyNDcxZDRjNjkyNDRjY2FkM2ZkMmUzOTlkNDVhNzIiLCJ1c2VyX2lkIjozM30.yNl-fIDxiTbLfkRKFrpSEuqhdxr5zp7ikfu9dv_8uHg', '2020-10-26 16:53:27.291336+02', '2020-10-27 16:53:27+02', 33, 'd42471d4c69244ccad3fd2e399d45a72');
INSERT INTO public.token_blacklist_outstandingtoken (id, token, created_at, expires_at, user_id, jti) VALUES (66, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTYwMzgxMDY5MiwianRpIjoiNTU3OTRiNDI1MzMwNDkwMTkwYzk5NzMwMWZkZGMxZDkiLCJ1c2VyX2lkIjozM30.hKCeE9TJc-k82g6jJESRuJeFODgXuoj5pE38HcBJlhA', '2020-10-26 16:58:12.085807+02', '2020-10-27 16:58:12+02', 33, '55794b425330490190c997301fddc1d9');
INSERT INTO public.token_blacklist_outstandingtoken (id, token, created_at, expires_at, user_id, jti) VALUES (67, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTYwMzgxMDcxMywianRpIjoiZTk3N2U5MWZkODFkNDI3ZGExZThkMWY5ZjcxN2Q1MDIiLCJ1c2VyX2lkIjozM30.M6mfIM1ydGSiPMHOcp9cn53Ci7AjVcIwH3YG4a16Or4', '2020-10-26 16:58:33.838179+02', '2020-10-27 16:58:33+02', 33, 'e977e91fd81d427da1e8d1f9f717d502');
INSERT INTO public.token_blacklist_outstandingtoken (id, token, created_at, expires_at, user_id, jti) VALUES (68, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTYwMzgxMDg4NCwianRpIjoiYWJiYjI2NjU2YWQ3NDUzMjg0YzkxZTgzYzkwOGY1OWUiLCJ1c2VyX2lkIjozM30.ZEhG940TxPu0kevDNaDBeohK4ycVQDK-sqavwCmCyv4', '2020-10-26 17:01:24.977428+02', '2020-10-27 17:01:24+02', 33, 'abbb26656ad7453284c91e83c908f59e');
INSERT INTO public.token_blacklist_outstandingtoken (id, token, created_at, expires_at, user_id, jti) VALUES (69, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTYwMzgxMTc2MiwianRpIjoiMTNiYWMyMzg1YjllNDM5MWFhMTY3Mjk3NDMxMzVjMDAiLCJ1c2VyX2lkIjozM30.ZKlAb8gndHYDWmorGhFFnsCa1rqvV_qsnowtFhHEB2Q', '2020-10-26 17:16:02.060521+02', '2020-10-27 17:16:02+02', 33, '13bac2385b9e4391aa16729743135c00');
INSERT INTO public.token_blacklist_outstandingtoken (id, token, created_at, expires_at, user_id, jti) VALUES (70, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTYwMzgxMTc4MSwianRpIjoiY2IwNmFhZDFjNjMwNDgwZWIyMDJiNmM4ZWFhY2I0ZTAiLCJ1c2VyX2lkIjozM30.yP42tKlCoOsu3dOGhDU6KzgbHxD-Mf8Uw7fD13qjvjY', '2020-10-26 17:16:21.838261+02', '2020-10-27 17:16:21+02', 33, 'cb06aad1c630480eb202b6c8eaacb4e0');
INSERT INTO public.token_blacklist_outstandingtoken (id, token, created_at, expires_at, user_id, jti) VALUES (71, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTYwMzgxMTg5OSwianRpIjoiYmE5OTM0OGVjYzNhNGZkM2EyYjg5NTc3MjU4YTc1ODIiLCJ1c2VyX2lkIjozM30._9FsfpfJW_SmwYBGgaqYn8nIy2hKs9fZ5cUSqjm04xg', '2020-10-26 17:18:19.873163+02', '2020-10-27 17:18:19+02', 33, 'ba99348ecc3a4fd3a2b89577258a7582');
INSERT INTO public.token_blacklist_outstandingtoken (id, token, created_at, expires_at, user_id, jti) VALUES (72, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTYwMzgxMTkyNSwianRpIjoiYjkyM2I3Mjc4ZmNmNGQ5ZGE4ODdmMDNkOTU1Yzk0ZjIiLCJ1c2VyX2lkIjozM30.TUgaP56hB427HjUUrM7vewsDK7Mm1M3KTLPoNkIn73I', '2020-10-26 17:18:45.545159+02', '2020-10-27 17:18:45+02', 33, 'b923b7278fcf4d9da887f03d955c94f2');
INSERT INTO public.token_blacklist_outstandingtoken (id, token, created_at, expires_at, user_id, jti) VALUES (73, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTYwMzgxMTk0NiwianRpIjoiOTU3ZDgzZGJjNGNjNDRmZjllOTM5OWRhNGU2MTQxNmQiLCJ1c2VyX2lkIjozM30.Mne6YmYpxTZkSN0ZXzIUxuDyhusBXkhtQ7M-XyvbDr4', '2020-10-26 17:19:06.512208+02', '2020-10-27 17:19:06+02', 33, '957d83dbc4cc44ff9e9399da4e61416d');
INSERT INTO public.token_blacklist_outstandingtoken (id, token, created_at, expires_at, user_id, jti) VALUES (74, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTYwMzgxMTk0NiwianRpIjoiODExY2Y3MmVjMzRmNGQ0NGEwNWYyMTIzY2UyYWExNWQiLCJ1c2VyX2lkIjozM30.zR0_2itXkS42eoKsr8rZPsEsYMw8296-i_3XVqD4_qE', '2020-10-26 17:19:06.52353+02', '2020-10-27 17:19:06+02', 33, '811cf72ec34f4d44a05f2123ce2aa15d');
INSERT INTO public.token_blacklist_outstandingtoken (id, token, created_at, expires_at, user_id, jti) VALUES (75, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTYwMzgxOTIyNiwianRpIjoiMjk0MWFhOGY3MjUwNDEyMjhiN2JjYTQ1ZmRkM2E5YjYiLCJ1c2VyX2lkIjozM30.jVcEGEfeS_G4Y2FuZz9VKCtgD1DqRINkesL4tChkoWk', '2020-10-26 19:20:26.931625+02', '2020-10-27 19:20:26+02', 33, '2941aa8f725041228b7bca45fdd3a9b6');
INSERT INTO public.token_blacklist_outstandingtoken (id, token, created_at, expires_at, user_id, jti) VALUES (76, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTYwMzgxOTIyNiwianRpIjoiY2Y3YzRjYjY3YzAxNDRlNzgwNDNiM2ZmMjE5NjgwOGMiLCJ1c2VyX2lkIjozM30.3hCiYBivo4piBE2Fv-qFdx6yYAONaNTs83PpY1xHkvI', '2020-10-26 19:20:26.957565+02', '2020-10-27 19:20:26+02', 33, 'cf7c4cb67c0144e78043b3ff2196808c');
INSERT INTO public.token_blacklist_outstandingtoken (id, token, created_at, expires_at, user_id, jti) VALUES (77, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTYwMzg2MjQzNCwianRpIjoiZWM3Y2NkYWE4YjhkNGMwNzk1M2U1MmUzYzAxYjNhNzEiLCJ1c2VyX2lkIjozM30.qZ5GJvcnlTwQFbjxPu9Rde-YMKUMlhJ_hX2yBUSZFIM', '2020-10-27 07:20:34.950459+02', '2020-10-28 07:20:34+02', 33, 'ec7ccdaa8b8d4c07953e52e3c01b3a71');
INSERT INTO public.token_blacklist_outstandingtoken (id, token, created_at, expires_at, user_id, jti) VALUES (78, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTYwMzg2MjQzNCwianRpIjoiZmU3OTQ3MDI1ZGIxNDFmY2I4YzI0OTQ5ZmJiZTYwYTQiLCJ1c2VyX2lkIjozM30.Y-TmWzTf_sVqwDALlMOnK7k-GYVTpXnTRGak2Kdzogc', '2020-10-27 07:20:34.980399+02', '2020-10-28 07:20:34+02', 33, 'fe7947025db141fcb8c24949fbbe60a4');
INSERT INTO public.token_blacklist_outstandingtoken (id, token, created_at, expires_at, user_id, jti) VALUES (79, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTYwMzg4MjgyNiwianRpIjoiNTFmOWEyNjcwNDY5NDFlYzhmZDhhYjMzZjM1MTQzYzgiLCJ1c2VyX2lkIjozNn0.okKV6JPaecWOYqhhpWL9IxL1hrBr4NAgZlCPkrXgBmE', '2020-10-27 13:00:26.501499+02', '2020-10-28 13:00:26+02', 36, '51f9a267046941ec8fd8ab33f35143c8');
INSERT INTO public.token_blacklist_outstandingtoken (id, token, created_at, expires_at, user_id, jti) VALUES (80, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTYwMzg4MjgyOCwianRpIjoiM2M1Yjc3ODAwYzRjNGI3ODlmNzc3N2Y1N2UzZjkzM2QiLCJ1c2VyX2lkIjozNn0.soxYlBluPBDg0FU4w_MXt5j9SZppX8-RGn7bZf-aU24', '2020-10-27 13:00:28.010588+02', '2020-10-28 13:00:28+02', 36, '3c5b77800c4c4b789f7777f57e3f933d');
INSERT INTO public.token_blacklist_outstandingtoken (id, token, created_at, expires_at, user_id, jti) VALUES (81, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTYwMzg4MjkwMCwianRpIjoiMWVhYmJjMTJhYzY2NDkwZmJjZjhmMDI3ZWRjZDczMmEiLCJ1c2VyX2lkIjozN30.WexCUQt7Ischn3uyOB3kWZ8Xi9w-d1pG4Wq5fObRTr0', '2020-10-27 13:01:40.366111+02', '2020-10-28 13:01:40+02', 37, '1eabbc12ac66490fbcf8f027edcd732a');
INSERT INTO public.token_blacklist_outstandingtoken (id, token, created_at, expires_at, user_id, jti) VALUES (82, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTYwMzg4MjkwMSwianRpIjoiZTcxZTM4YmY0OGQ5NDVjYTgxM2I0YWY2ZDVjY2JkMjQiLCJ1c2VyX2lkIjozN30.n5GYnPGF3koEL2oMW2T5wUk5fxROzQCUSlBN27jOJCQ', '2020-10-27 13:01:41.884317+02', '2020-10-28 13:01:41+02', 37, 'e71e38bf48d945ca813b4af6d5ccbd24');
INSERT INTO public.token_blacklist_outstandingtoken (id, token, created_at, expires_at, user_id, jti) VALUES (83, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTYwMzg4Mjk3OCwianRpIjoiN2IxNzY5YzViMTM1NDQ0MWFhZDNlNWIwYjQyZmQ0YTciLCJ1c2VyX2lkIjozOH0.rbU6jq6KQ-DHNndg6TtHfxlRzVO_zxIs7jO6fVvbXmE', '2020-10-27 13:02:58.276687+02', '2020-10-28 13:02:58+02', 38, '7b1769c5b1354441aad3e5b0b42fd4a7');
INSERT INTO public.token_blacklist_outstandingtoken (id, token, created_at, expires_at, user_id, jti) VALUES (84, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTYwMzg4Mjk3OSwianRpIjoiNmUwNWY4NjQ5ODI0NDM3M2JmZTFjZmVlY2MxMjQ2NjkiLCJ1c2VyX2lkIjozOH0.WX9_DG2KSNMWv0CRxmdW14JRLPo-ng6zmPW9AEUyjng', '2020-10-27 13:02:59.963326+02', '2020-10-28 13:02:59+02', 38, '6e05f86498244373bfe1cfeecc124669');
INSERT INTO public.token_blacklist_outstandingtoken (id, token, created_at, expires_at, user_id, jti) VALUES (85, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTYwMzg4MzM5NywianRpIjoiNzU1MTcyOGU2YzY2NGY4MTk0YTlkZDA3ODg2OWRkMjEiLCJ1c2VyX2lkIjozOX0.m2IzhfbJAK8KJTU4PkaLaUxnVfkZ_Rgc8VzynG5I9Ao', '2020-10-27 13:09:57.282853+02', '2020-10-28 13:09:57+02', 39, '7551728e6c664f8194a9dd078869dd21');
INSERT INTO public.token_blacklist_outstandingtoken (id, token, created_at, expires_at, user_id, jti) VALUES (86, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTYwMzg4MzM5OCwianRpIjoiYWEzYmQ1MDg3Y2VhNDBjMjhhYjYzNDk1YmFkZmZlM2QiLCJ1c2VyX2lkIjozOX0.EzYRd4mcy5aHrPn5bo40a07NH8pi9zLspJNrvPhJ2VA', '2020-10-27 13:09:58.799492+02', '2020-10-28 13:09:58+02', 39, 'aa3bd5087cea40c28ab63495badffe3d');
INSERT INTO public.token_blacklist_outstandingtoken (id, token, created_at, expires_at, user_id, jti) VALUES (87, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTYwMzg4Mzc0NSwianRpIjoiZjFlYzdkNzBhNTc1NDdjYzlkZmFhYWRmZDdjYWEyZGMiLCJ1c2VyX2lkIjo0MH0.i8kb49e50kYUa7vtHUbSdLyN6es4DK64pnZ7JZA1bGM', '2020-10-27 13:15:45.401815+02', '2020-10-28 13:15:45+02', 40, 'f1ec7d70a57547cc9dfaaadfd7caa2dc');
INSERT INTO public.token_blacklist_outstandingtoken (id, token, created_at, expires_at, user_id, jti) VALUES (88, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTYwMzg4Mzc0NiwianRpIjoiNTRjYmM0ODM4MDliNDI1MDlmYTFhNDI1NDEzMTRiMDkiLCJ1c2VyX2lkIjo0MH0.HbZ67nJ9QnVDg0BQJOtDEUyPSWa2BPU-kveubHOR4Is', '2020-10-27 13:15:46.88767+02', '2020-10-28 13:15:46+02', 40, '54cbc483809b42509fa1a42541314b09');
INSERT INTO public.token_blacklist_outstandingtoken (id, token, created_at, expires_at, user_id, jti) VALUES (89, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTYwMzg4Mzg0NCwianRpIjoiYWVjMmYxYzg2N2U5NDRjNjljNWU3MmJhODYwNGFiNjUiLCJ1c2VyX2lkIjo0MX0.gATMPdp4joVRQMhpxW6ZojmsrGJUhsdynBRbJq3TeS4', '2020-10-27 13:17:24.11894+02', '2020-10-28 13:17:24+02', 41, 'aec2f1c867e944c69c5e72ba8604ab65');
INSERT INTO public.token_blacklist_outstandingtoken (id, token, created_at, expires_at, user_id, jti) VALUES (90, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTYwMzg4Mzg0NSwianRpIjoiZGMzOTFiYmY1NTBjNDkxZDhiNTg2YjFhZDg2ODkzMzAiLCJ1c2VyX2lkIjo0MX0.RvA8we_2ll9jjcwifF1fpIzTw0-s8ghHFGKLcRJ1kcg', '2020-10-27 13:17:25.58729+02', '2020-10-28 13:17:25+02', 41, 'dc391bbf550c491d8b586b1ad8689330');
INSERT INTO public.token_blacklist_outstandingtoken (id, token, created_at, expires_at, user_id, jti) VALUES (91, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTYwMzg4Mzg2NiwianRpIjoiNzFmNTE2M2NjMzAxNDllY2IxMWQ1ZWQwNjNmMDQ3NjMiLCJ1c2VyX2lkIjo0Mn0.i7ahvxmEDygfaGXecnhbj44XUYgxVBe-YY5s_dvam54', '2020-10-27 13:17:46.787071+02', '2020-10-28 13:17:46+02', 42, '71f5163cc30149ecb11d5ed063f04763');
INSERT INTO public.token_blacklist_outstandingtoken (id, token, created_at, expires_at, user_id, jti) VALUES (92, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTYwMzg4Mzg2OCwianRpIjoiYjM1Nzc4YjAwNDZjNDQ2MGExZmYyYjc0Zjk0ODkxYzUiLCJ1c2VyX2lkIjo0Mn0.hn8uVoEkSMZ6QhDvOqwBZN4dMXxD8BsDSW5B4hLGNkA', '2020-10-27 13:17:48.268473+02', '2020-10-28 13:17:48+02', 42, 'b35778b0046c4460a1ff2b74f94891c5');
INSERT INTO public.token_blacklist_outstandingtoken (id, token, created_at, expires_at, user_id, jti) VALUES (93, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTYwMzg4NDcxOCwianRpIjoiMmY4NGIzNmY0YjhiNDRhYWE2ODU5YTUxZDg1OTZjMTIiLCJ1c2VyX2lkIjozM30.cfpjwRDpnf_O3VOxd7k-Tl2mBsmKmlMW0xJcyako8aY', '2020-10-27 13:31:58.643209+02', '2020-10-28 13:31:58+02', 33, '2f84b36f4b8b44aaa6859a51d8596c12');
INSERT INTO public.token_blacklist_outstandingtoken (id, token, created_at, expires_at, user_id, jti) VALUES (94, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTYwMzg4NDcxOCwianRpIjoiNmY3YTBiN2ExMGE4NDJmY2E3MGUzNTQ0NTRlOWExOGQiLCJ1c2VyX2lkIjozM30.rxfEnryt62IVcwzMLNOibgtFfFnucUWNZwgRl-EbrkU', '2020-10-27 13:31:58.664707+02', '2020-10-28 13:31:58+02', 33, '6f7a0b7a10a842fca70e354454e9a18d');
INSERT INTO public.token_blacklist_outstandingtoken (id, token, created_at, expires_at, user_id, jti) VALUES (95, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTYwMzg5OTI2NywianRpIjoiY2ZlNWE3YzJmYWRlNDNmMzg0ZDRiM2FlYzMzNjBiMGIiLCJ1c2VyX2lkIjo0Mn0.4u6CgjgTGgtX8Zl-klXFqkeOFz6UK42-Vu_TFGNAeR4', '2020-10-27 17:34:27.341682+02', '2020-10-28 17:34:27+02', 42, 'cfe5a7c2fade43f384d4b3aec3360b0b');
INSERT INTO public.token_blacklist_outstandingtoken (id, token, created_at, expires_at, user_id, jti) VALUES (96, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTYwMzg5OTI2NywianRpIjoiYmM0ZTQzYWJkNjM5NDM1N2I1NDVkMmI1OTY4MDc2YjciLCJ1c2VyX2lkIjo0Mn0.f6LEszEs-y9JuM6IBQYQeSdtVH8Fz_tQl24xt4K4W6g', '2020-10-27 17:34:27.356643+02', '2020-10-28 17:34:27+02', 42, 'bc4e43abd6394357b545d2b5968076b7');
INSERT INTO public.token_blacklist_outstandingtoken (id, token, created_at, expires_at, user_id, jti) VALUES (97, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTYwMzkwMDA4NywianRpIjoiNzcxYWRmZmU4NzNhNGE2NDhlYWM5MTFlMmI3NjFmMzAiLCJ1c2VyX2lkIjo0M30.1IvL9tgiwu7r-QcFWgVRJPBYqGXfUsDLb2_pRV6KZmQ', '2020-10-27 17:48:07.978506+02', '2020-10-28 17:48:07+02', 43, '771adffe873a4a648eac911e2b761f30');
INSERT INTO public.token_blacklist_outstandingtoken (id, token, created_at, expires_at, user_id, jti) VALUES (98, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTYwMzkwMDA4OSwianRpIjoiYWIzNmZlZGJlZjdmNDY3NGJkM2Q2Mzc3YTc1Y2VmMTciLCJ1c2VyX2lkIjo0M30.8HcaslK5C_OlgyY34M3KGIPJJLXFjrYsPqIRkp1PygE', '2020-10-27 17:48:09.481682+02', '2020-10-28 17:48:09+02', 43, 'ab36fedbef7f4674bd3d6377a75cef17');
INSERT INTO public.token_blacklist_outstandingtoken (id, token, created_at, expires_at, user_id, jti) VALUES (99, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTYwMzkwMDEwMiwianRpIjoiMmU0ZjkzYTBhOTAyNGRlN2I5NzhmNTBiYWQ2ZmFmYjUiLCJ1c2VyX2lkIjo0NH0.4WzA10hARf9g9Dtq6K8nQttAFANjDDU2ocG0hRVEWyE', '2020-10-27 17:48:22.914224+02', '2020-10-28 17:48:22+02', 44, '2e4f93a0a9024de7b978f50bad6fafb5');
INSERT INTO public.token_blacklist_outstandingtoken (id, token, created_at, expires_at, user_id, jti) VALUES (100, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTYwMzkwMDEwNCwianRpIjoiZjkyY2JiYWUyODc0NDMzMDgyN2UzMDBkNWMxYTM5NTUiLCJ1c2VyX2lkIjo0NH0.hES529ObxVXeKsZqbUB7v7kf-qo7ho9nPfeKlS1_35w', '2020-10-27 17:48:24.321513+02', '2020-10-28 17:48:24+02', 44, 'f92cbbae28744330827e300d5c1a3955');
INSERT INTO public.token_blacklist_outstandingtoken (id, token, created_at, expires_at, user_id, jti) VALUES (101, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTYwMzkwMDExOSwianRpIjoiMjAwZjEyNzI1OTc2NDgxMGEwNWMwNjg4ODkwOTM5MzAiLCJ1c2VyX2lkIjo0NX0.KzpMew0EDzXQJpJeo-agYMnEhIv3g46LN5yTG69Ytzo', '2020-10-27 17:48:39.145284+02', '2020-10-28 17:48:39+02', 45, '200f127259764810a05c068889093930');
INSERT INTO public.token_blacklist_outstandingtoken (id, token, created_at, expires_at, user_id, jti) VALUES (102, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTYwMzkwMDEyMCwianRpIjoiNzQyYjk0MTMxNTdlNDJmNWEwMmMzMzYxM2E4OGMzODMiLCJ1c2VyX2lkIjo0NX0.I54YCaupUo3vwzTQhiKUz_OKIVVyFRWLyhgvECbDltY', '2020-10-27 17:48:40.597503+02', '2020-10-28 17:48:40+02', 45, '742b9413157e42f5a02c33613a88c383');
INSERT INTO public.token_blacklist_outstandingtoken (id, token, created_at, expires_at, user_id, jti) VALUES (103, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTYwMzkwMzQ0NSwianRpIjoiYzA1N2M0ODk5NjUxNDk4MTk3OThlMDZlNjZiNGNiYmYiLCJ1c2VyX2lkIjo0Mn0.g5MpYjCNC29xtHZ4b_bJ6wrnAcGTP-l55Tr10HrhFPU', '2020-10-27 18:44:05.084128+02', '2020-10-28 18:44:05+02', 42, 'c057c489965149819798e06e66b4cbbf');
INSERT INTO public.token_blacklist_outstandingtoken (id, token, created_at, expires_at, user_id, jti) VALUES (104, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTYwMzkwMzQ0NSwianRpIjoiZDIxYzAxOWIyZTc5NDg5ODliNTBhOWM1MDdlMWE0ZmMiLCJ1c2VyX2lkIjo0Mn0.G2QID4AdM6jtMPUC-40iEg3tnuL8qNO2z_kDLpi7zL8', '2020-10-27 18:44:05.093103+02', '2020-10-28 18:44:05+02', 42, 'd21c019b2e7948989b50a9c507e1a4fc');
INSERT INTO public.token_blacklist_outstandingtoken (id, token, created_at, expires_at, user_id, jti) VALUES (105, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTYwNDA4ODg5MCwianRpIjoiNDQ3YjQ3MWQ1YWRjNDlkZWE2ZmZlZThmNTg0M2NkNGUiLCJ1c2VyX2lkIjo0Mn0.l0Tn_vPPieBqYqlWyBx9bEKyqjDKtxckSxCe6yrRHnM', '2020-10-29 22:14:50.577631+02', '2020-10-30 22:14:50+02', 42, '447b471d5adc49dea6ffee8f5843cd4e');
INSERT INTO public.token_blacklist_outstandingtoken (id, token, created_at, expires_at, user_id, jti) VALUES (106, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTYwNDA4ODg5MCwianRpIjoiNmY3MGY4Y2E1NDA4NGExYTg3ZWI5YmQ1ZDQ2ZTY0ZmMiLCJ1c2VyX2lkIjo0Mn0.ByvCYcbj2FLwQJHEp8PefQQ_hFMSmhNLtEqZelDR8E0', '2020-10-29 22:14:50.608144+02', '2020-10-30 22:14:50+02', 42, '6f70f8ca54084a1a87eb9bd5d46e64fc');
INSERT INTO public.token_blacklist_outstandingtoken (id, token, created_at, expires_at, user_id, jti) VALUES (107, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTYwNDA4ODkzMCwianRpIjoiODk3NzA4MTg0ZDQ1NDM4MzgxYjc1NmU3OGVhZjQwMDgiLCJ1c2VyX2lkIjozM30.xMhDLt45a2NRyjfi_Q87IWCerrX8PYC-zQI_c2Gia9o', '2020-10-29 22:15:30.705481+02', '2020-10-30 22:15:30+02', 33, '897708184d45438381b756e78eaf4008');
INSERT INTO public.token_blacklist_outstandingtoken (id, token, created_at, expires_at, user_id, jti) VALUES (108, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTYwNDA4ODkzMCwianRpIjoiNzMxMWE0ZmI5YmZiNDhhN2FkNWRlY2E5MmZiMzEwZmUiLCJ1c2VyX2lkIjozM30.gtWuS8HaKHnz5Jaa6ass1uNzDzj6x-lWPOujl-kiTyI', '2020-10-29 22:15:30.717462+02', '2020-10-30 22:15:30+02', 33, '7311a4fb9bfb48a7ad5deca92fb310fe');
INSERT INTO public.token_blacklist_outstandingtoken (id, token, created_at, expires_at, user_id, jti) VALUES (109, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTYwNDE0MzA5OCwianRpIjoiYjljOTU3YzdjNDdhNGUwNTg4NmY1ZjllZGUxZDdhOWUiLCJ1c2VyX2lkIjozM30.GjdK7LI4VXmIfrmS6uTVzi3cewyA9U6sAsaXp3e5G7M', '2020-10-30 13:18:18.519144+02', '2020-10-31 13:18:18+02', 33, 'b9c957c7c47a4e05886f5f9ede1d7a9e');
INSERT INTO public.token_blacklist_outstandingtoken (id, token, created_at, expires_at, user_id, jti) VALUES (110, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTYwNDE0MzA5OCwianRpIjoiMWM2NjM0ZjMyNTY2NDM4YmFjNTM1NzRlYjA5ZDgwMjIiLCJ1c2VyX2lkIjozM30.luTV1nNYtWODNZUSX0eejdShMtGPXa8cKk6FFYh880c', '2020-10-30 13:18:18.540191+02', '2020-10-31 13:18:18+02', 33, '1c6634f32566438bac53574eb09d8022');
INSERT INTO public.token_blacklist_outstandingtoken (id, token, created_at, expires_at, user_id, jti) VALUES (111, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTYwNDI2NDgyNiwianRpIjoiN2M5MmFiNzcxMmZlNGZjMWJlNjNiYzYzMjZhMTM4YTEiLCJ1c2VyX2lkIjozM30.Kt8pLb6he3kyNWeJI412K2sD7XOjsgvDvTNetOvYChc', '2020-10-31 23:07:06.166136+02', '2020-11-01 23:07:06+02', 33, '7c92ab7712fe4fc1be63bc6326a138a1');
INSERT INTO public.token_blacklist_outstandingtoken (id, token, created_at, expires_at, user_id, jti) VALUES (112, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTYwNDI2NDgyNiwianRpIjoiZTM1ZmU3YjY3NGQ2NDgxOWEzZGFiYThhMmI2OGM2NzYiLCJ1c2VyX2lkIjozM30.HtiywwRuxXRFh-69QfKrAsO7uOc9p5ZegByPR24q0fI', '2020-10-31 23:07:06.285198+02', '2020-11-01 23:07:06+02', 33, 'e35fe7b674d64819a3daba8a2b68c676');
INSERT INTO public.token_blacklist_outstandingtoken (id, token, created_at, expires_at, user_id, jti) VALUES (113, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTYwNDI2NDk0NiwianRpIjoiYzEwYzNmMmE3MTkxNGJlODhiMjE0ODYxOTY3ZTdhYTkiLCJ1c2VyX2lkIjozM30.RJc_6ALg50sSraNQmGcOixV0_DGEQPOrUmlN47joGVg', '2020-10-31 23:09:06.936893+02', '2020-11-01 23:09:06+02', 33, 'c10c3f2a71914be88b214861967e7aa9');
INSERT INTO public.token_blacklist_outstandingtoken (id, token, created_at, expires_at, user_id, jti) VALUES (114, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTYwNDI2NDk0NiwianRpIjoiZjNiYWRkODMxNjBkNDdiNGIwZjA1NzVhODQ3NDVjZjMiLCJ1c2VyX2lkIjozM30.XCzTa0S14P33SNVVd7Wd8NSGCx9swO25AbD7xmUxtLw', '2020-10-31 23:09:06.948387+02', '2020-11-01 23:09:06+02', 33, 'f3badd83160d47b4b0f0575a84745cf3');
INSERT INTO public.token_blacklist_outstandingtoken (id, token, created_at, expires_at, user_id, jti) VALUES (115, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTYwNDI2NTAwMSwianRpIjoiNzRjYTA2NGU5MWY5NGNkNzg3OWJiNWI4YzcyNzRlMTciLCJ1c2VyX2lkIjozM30.izX9ikaKG0TSWCRLq5k8YCLvvwLpkfkSlW3bWUxrpWo', '2020-10-31 23:10:01.264+02', '2020-11-01 23:10:01+02', 33, '74ca064e91f94cd7879bb5b8c7274e17');
INSERT INTO public.token_blacklist_outstandingtoken (id, token, created_at, expires_at, user_id, jti) VALUES (116, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTYwNDI2NTAwMSwianRpIjoiNTQ2YThlZjM0NjZlNDQyMDk0MjliMWI4M2FmYTBjYTUiLCJ1c2VyX2lkIjozM30.7He5f_VSnDUC0TD9OOcUanzGdWSDxMAljaQEduMcxGA', '2020-10-31 23:10:01.274971+02', '2020-11-01 23:10:01+02', 33, '546a8ef3466e44209429b1b83afa0ca5');
INSERT INTO public.token_blacklist_outstandingtoken (id, token, created_at, expires_at, user_id, jti) VALUES (117, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTYwNDI2NTExMywianRpIjoiNGM2N2RmNTM5YmM0NDFjMGJlZDEyYzdhYWEwNGRmYWIiLCJ1c2VyX2lkIjozM30.9fZnx32VCzbEn-e0AtxxxrC-IoDUGcOhQlgrwWIPAQ0', '2020-10-31 23:11:53.397759+02', '2020-11-01 23:11:53+02', 33, '4c67df539bc441c0bed12c7aaa04dfab');
INSERT INTO public.token_blacklist_outstandingtoken (id, token, created_at, expires_at, user_id, jti) VALUES (118, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTYwNDI2NTExMywianRpIjoiYjI0ZTQ4MTA1NzQ2NGI2YWI2ODFjNTkxOWMyNzdiOTEiLCJ1c2VyX2lkIjozM30.YH8qcmEpXvLIil_wg0vhzfXE2wGsq1Yt2UO4MiAlW0U', '2020-10-31 23:11:53.418664+02', '2020-11-01 23:11:53+02', 33, 'b24e481057464b6ab681c5919c277b91');
INSERT INTO public.token_blacklist_outstandingtoken (id, token, created_at, expires_at, user_id, jti) VALUES (119, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTYwNDI2NjY1NiwianRpIjoiN2I0YzA1ZTdkMjU1NDcwM2JhYWE5Y2IwOGY5MDQ0MzciLCJ1c2VyX2lkIjozM30.B70HOPfS2VCVgHtuEj_5NPHeXEc9BNfSXRC-JI_bn1Y', '2020-10-31 23:37:36.725129+02', '2020-11-01 23:37:36+02', 33, '7b4c05e7d2554703baaa9cb08f904437');
INSERT INTO public.token_blacklist_outstandingtoken (id, token, created_at, expires_at, user_id, jti) VALUES (120, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTYwNDI2NjY1NiwianRpIjoiZTJlN2I1ZDQ5OTVmNGUzYWE2MDVkODEyOWJhMDM0NGEiLCJ1c2VyX2lkIjozM30.PyB6Oj2NgmXNFB-O_cCYH5EOj9TH6JxxHDl7XbScAjQ', '2020-10-31 23:37:36.736061+02', '2020-11-01 23:37:36+02', 33, 'e2e7b5d4995f4e3aa605d8129ba0344a');


--
-- Data for Name: user_guide; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.user_guide (id, title, content, created_at, updated_at, owner_id) VALUES (1, 'User Guide Test', 'User guide content', '2020-10-23 21:02:42.845812+03', '2020-10-23 21:02:42.845812+03', 2);
INSERT INTO public.user_guide (id, title, content, created_at, updated_at, owner_id) VALUES (2, 'User Guide Test2', 'User guide content', '2020-10-24 02:31:16.592888+03', '2020-10-24 02:31:16.592888+03', 2);
INSERT INTO public.user_guide (id, title, content, created_at, updated_at, owner_id) VALUES (3, 'User Guide Test2', 'User guide content', '2020-10-24 02:42:26.355923+03', '2020-10-24 02:42:26.355923+03', 2);
INSERT INTO public.user_guide (id, title, content, created_at, updated_at, owner_id) VALUES (4, 'User Guide Test2', 'User guide content', '2020-10-26 21:30:29.030986+02', '2020-10-26 21:30:29.030986+02', 33);


--
-- Data for Name: user_guide_uploads; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.user_guide_uploads (id, name, file, size, created_at, user_guide_id) VALUES (1, 'Testing', 'test.png', 0, '2020-10-23 21:25:54.717344+03', 1);
INSERT INTO public.user_guide_uploads (id, name, file, size, created_at, user_guide_id) VALUES (2, 'image_2020_10_08T06_19_04_359Z.png', 'image_2020_10_08T06_19_04_359Z.png', 243020, '2020-10-23 21:29:43.381443+03', 1);


--
-- Name: accounts_account_groups_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.accounts_account_groups_id_seq', 1, false);


--
-- Name: accounts_account_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.accounts_account_id_seq', 45, true);


--
-- Name: accounts_account_user_permissions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.accounts_account_user_permissions_id_seq', 1, false);


--
-- Name: admin_enterprise_config_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.admin_enterprise_config_id_seq', 3, true);


--
-- Name: analytics_activitylog_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.analytics_activitylog_id_seq', 8, true);


--
-- Name: analytics_analytics_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.analytics_analytics_id_seq', 1, false);


--
-- Name: auth_group_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.auth_group_id_seq', 1, false);


--
-- Name: auth_group_permissions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.auth_group_permissions_id_seq', 1, false);


--
-- Name: auth_permission_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.auth_permission_id_seq', 92, true);


--
-- Name: consumer_requests_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.consumer_requests_id_seq', 28, true);


--
-- Name: customer_uploads_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.customer_uploads_id_seq', 1, false);


--
-- Name: customers_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.customers_id_seq', 33, true);


--
-- Name: django_admin_log_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.django_admin_log_id_seq', 1, false);


--
-- Name: django_content_type_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.django_content_type_id_seq', 23, true);


--
-- Name: django_migrations_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.django_migrations_id_seq', 71, true);


--
-- Name: enterprise_configuration_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.enterprise_configuration_id_seq', 4, true);


--
-- Name: enterprise_customer_configuration_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.enterprise_customer_configuration_id_seq', 1, false);


--
-- Name: enterprises_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.enterprises_id_seq', 8, true);


--
-- Name: otp_static_staticdevice_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.otp_static_staticdevice_id_seq', 1, false);


--
-- Name: otp_static_statictoken_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.otp_static_statictoken_id_seq', 1, false);


--
-- Name: otp_totp_totpdevice_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.otp_totp_totpdevice_id_seq', 1, false);


--
-- Name: token_blacklist_blacklistedtoken_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.token_blacklist_blacklistedtoken_id_seq', 1, false);


--
-- Name: token_blacklist_outstandingtoken_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.token_blacklist_outstandingtoken_id_seq', 120, true);


--
-- Name: user_guide_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.user_guide_id_seq', 4, true);


--
-- Name: user_guide_uploads_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.user_guide_uploads_id_seq', 2, true);


--
-- Name: accounts_account accounts_account_email_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.accounts_account
    ADD CONSTRAINT accounts_account_email_key UNIQUE (email);


--
-- Name: accounts_account_groups accounts_account_groups_account_id_group_id_f64165b0_uniq; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.accounts_account_groups
    ADD CONSTRAINT accounts_account_groups_account_id_group_id_f64165b0_uniq UNIQUE (account_id, group_id);


--
-- Name: accounts_account_groups accounts_account_groups_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.accounts_account_groups
    ADD CONSTRAINT accounts_account_groups_pkey PRIMARY KEY (id);


--
-- Name: accounts_account accounts_account_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.accounts_account
    ADD CONSTRAINT accounts_account_pkey PRIMARY KEY (id);


--
-- Name: accounts_account_user_permissions accounts_account_user_pe_account_id_permission_id_9af93c14_uniq; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.accounts_account_user_permissions
    ADD CONSTRAINT accounts_account_user_pe_account_id_permission_id_9af93c14_uniq UNIQUE (account_id, permission_id);


--
-- Name: accounts_account_user_permissions accounts_account_user_permissions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.accounts_account_user_permissions
    ADD CONSTRAINT accounts_account_user_permissions_pkey PRIMARY KEY (id);


--
-- Name: accounts_account accounts_account_username_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.accounts_account
    ADD CONSTRAINT accounts_account_username_key UNIQUE (username);


--
-- Name: admin_enterprise_config admin_enterprise_config_key_050aa01c_uniq; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.admin_enterprise_config
    ADD CONSTRAINT admin_enterprise_config_key_050aa01c_uniq UNIQUE (key);


--
-- Name: admin_enterprise_config admin_enterprise_config_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.admin_enterprise_config
    ADD CONSTRAINT admin_enterprise_config_pkey PRIMARY KEY (id);


--
-- Name: analytics_activitylog analytics_activitylog_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.analytics_activitylog
    ADD CONSTRAINT analytics_activitylog_pkey PRIMARY KEY (id);


--
-- Name: analytics_analytics analytics_analytics_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.analytics_analytics
    ADD CONSTRAINT analytics_analytics_pkey PRIMARY KEY (id);


--
-- Name: auth_group auth_group_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_group
    ADD CONSTRAINT auth_group_name_key UNIQUE (name);


--
-- Name: auth_group_permissions auth_group_permissions_group_id_permission_id_0cd325b0_uniq; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_group_permissions
    ADD CONSTRAINT auth_group_permissions_group_id_permission_id_0cd325b0_uniq UNIQUE (group_id, permission_id);


--
-- Name: auth_group_permissions auth_group_permissions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_group_permissions
    ADD CONSTRAINT auth_group_permissions_pkey PRIMARY KEY (id);


--
-- Name: auth_group auth_group_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_group
    ADD CONSTRAINT auth_group_pkey PRIMARY KEY (id);


--
-- Name: auth_permission auth_permission_content_type_id_codename_01ab375a_uniq; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_permission
    ADD CONSTRAINT auth_permission_content_type_id_codename_01ab375a_uniq UNIQUE (content_type_id, codename);


--
-- Name: auth_permission auth_permission_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_permission
    ADD CONSTRAINT auth_permission_pkey PRIMARY KEY (id);


--
-- Name: consumer_requests consumer_requests_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.consumer_requests
    ADD CONSTRAINT consumer_requests_pkey PRIMARY KEY (id);


--
-- Name: customer_uploads customer_uploads_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.customer_uploads
    ADD CONSTRAINT customer_uploads_pkey PRIMARY KEY (id);


--
-- Name: customers customers_elroi_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.customers
    ADD CONSTRAINT customers_elroi_id_key UNIQUE (elroi_id);


--
-- Name: customers customers_email_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.customers
    ADD CONSTRAINT customers_email_key UNIQUE (email);


--
-- Name: customers customers_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.customers
    ADD CONSTRAINT customers_pkey PRIMARY KEY (id);


--
-- Name: customers customers_user_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.customers
    ADD CONSTRAINT customers_user_id_key UNIQUE (user_id);


--
-- Name: django_admin_log django_admin_log_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.django_admin_log
    ADD CONSTRAINT django_admin_log_pkey PRIMARY KEY (id);


--
-- Name: django_content_type django_content_type_app_label_model_76bd3d3b_uniq; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.django_content_type
    ADD CONSTRAINT django_content_type_app_label_model_76bd3d3b_uniq UNIQUE (app_label, model);


--
-- Name: django_content_type django_content_type_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.django_content_type
    ADD CONSTRAINT django_content_type_pkey PRIMARY KEY (id);


--
-- Name: django_migrations django_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.django_migrations
    ADD CONSTRAINT django_migrations_pkey PRIMARY KEY (id);


--
-- Name: django_session django_session_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.django_session
    ADD CONSTRAINT django_session_pkey PRIMARY KEY (session_key);


--
-- Name: enterprise_configuration enterprise_configuration_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.enterprise_configuration
    ADD CONSTRAINT enterprise_configuration_pkey PRIMARY KEY (id);


--
-- Name: enterprise_customer_configuration enterprise_customer_configuration_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.enterprise_customer_configuration
    ADD CONSTRAINT enterprise_customer_configuration_pkey PRIMARY KEY (id);


--
-- Name: enterprises enterprises_elroi_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.enterprises
    ADD CONSTRAINT enterprises_elroi_id_key UNIQUE (elroi_id);


--
-- Name: enterprises enterprises_email_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.enterprises
    ADD CONSTRAINT enterprises_email_key UNIQUE (email);


--
-- Name: enterprises enterprises_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.enterprises
    ADD CONSTRAINT enterprises_pkey PRIMARY KEY (id);


--
-- Name: enterprises enterprises_user_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.enterprises
    ADD CONSTRAINT enterprises_user_id_key UNIQUE (user_id);


--
-- Name: otp_static_staticdevice otp_static_staticdevice_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.otp_static_staticdevice
    ADD CONSTRAINT otp_static_staticdevice_pkey PRIMARY KEY (id);


--
-- Name: otp_static_statictoken otp_static_statictoken_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.otp_static_statictoken
    ADD CONSTRAINT otp_static_statictoken_pkey PRIMARY KEY (id);


--
-- Name: otp_totp_totpdevice otp_totp_totpdevice_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.otp_totp_totpdevice
    ADD CONSTRAINT otp_totp_totpdevice_pkey PRIMARY KEY (id);


--
-- Name: token_blacklist_blacklistedtoken token_blacklist_blacklistedtoken_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.token_blacklist_blacklistedtoken
    ADD CONSTRAINT token_blacklist_blacklistedtoken_pkey PRIMARY KEY (id);


--
-- Name: token_blacklist_blacklistedtoken token_blacklist_blacklistedtoken_token_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.token_blacklist_blacklistedtoken
    ADD CONSTRAINT token_blacklist_blacklistedtoken_token_id_key UNIQUE (token_id);


--
-- Name: token_blacklist_outstandingtoken token_blacklist_outstandingtoken_jti_hex_d9bdf6f7_uniq; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.token_blacklist_outstandingtoken
    ADD CONSTRAINT token_blacklist_outstandingtoken_jti_hex_d9bdf6f7_uniq UNIQUE (jti);


--
-- Name: token_blacklist_outstandingtoken token_blacklist_outstandingtoken_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.token_blacklist_outstandingtoken
    ADD CONSTRAINT token_blacklist_outstandingtoken_pkey PRIMARY KEY (id);


--
-- Name: user_guide user_guide_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_guide
    ADD CONSTRAINT user_guide_pkey PRIMARY KEY (id);


--
-- Name: user_guide_uploads user_guide_uploads_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_guide_uploads
    ADD CONSTRAINT user_guide_uploads_pkey PRIMARY KEY (id);


--
-- Name: accounts_account_email_348850e2_like; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX accounts_account_email_348850e2_like ON public.accounts_account USING btree (email varchar_pattern_ops);


--
-- Name: accounts_account_groups_account_id_52f14852; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX accounts_account_groups_account_id_52f14852 ON public.accounts_account_groups USING btree (account_id);


--
-- Name: accounts_account_groups_group_id_7c6a6bd1; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX accounts_account_groups_group_id_7c6a6bd1 ON public.accounts_account_groups USING btree (group_id);


--
-- Name: accounts_account_user_permissions_account_id_816f9bde; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX accounts_account_user_permissions_account_id_816f9bde ON public.accounts_account_user_permissions USING btree (account_id);


--
-- Name: accounts_account_user_permissions_permission_id_24620205; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX accounts_account_user_permissions_permission_id_24620205 ON public.accounts_account_user_permissions USING btree (permission_id);


--
-- Name: accounts_account_username_b5f69a28_like; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX accounts_account_username_b5f69a28_like ON public.accounts_account USING btree (username varchar_pattern_ops);


--
-- Name: admin_enterprise_config_created_by_id_fba789c9; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX admin_enterprise_config_created_by_id_fba789c9 ON public.admin_enterprise_config USING btree (created_by_id);


--
-- Name: admin_enterprise_config_key_050aa01c_like; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX admin_enterprise_config_key_050aa01c_like ON public.admin_enterprise_config USING btree (key varchar_pattern_ops);


--
-- Name: admin_enterprise_config_updated_by_id_2cdf5cb5; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX admin_enterprise_config_updated_by_id_2cdf5cb5 ON public.admin_enterprise_config USING btree (updated_by_id);


--
-- Name: analytics_activitylog_path_29cedd66; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX analytics_activitylog_path_29cedd66 ON public.analytics_activitylog USING btree (path);


--
-- Name: analytics_activitylog_path_29cedd66_like; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX analytics_activitylog_path_29cedd66_like ON public.analytics_activitylog USING btree (path varchar_pattern_ops);


--
-- Name: analytics_activitylog_requested_at_2d3a3500; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX analytics_activitylog_requested_at_2d3a3500 ON public.analytics_activitylog USING btree (requested_at);


--
-- Name: analytics_activitylog_user_id_d7739206; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX analytics_activitylog_user_id_d7739206 ON public.analytics_activitylog USING btree (user_id);


--
-- Name: analytics_activitylog_view_de64bb22; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX analytics_activitylog_view_de64bb22 ON public.analytics_activitylog USING btree (view);


--
-- Name: analytics_activitylog_view_de64bb22_like; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX analytics_activitylog_view_de64bb22_like ON public.analytics_activitylog USING btree (view varchar_pattern_ops);


--
-- Name: analytics_activitylog_view_method_31a9e8b2; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX analytics_activitylog_view_method_31a9e8b2 ON public.analytics_activitylog USING btree (view_method);


--
-- Name: analytics_activitylog_view_method_31a9e8b2_like; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX analytics_activitylog_view_method_31a9e8b2_like ON public.analytics_activitylog USING btree (view_method varchar_pattern_ops);


--
-- Name: analytics_analytics_content_type_id_ad8f9e9c; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX analytics_analytics_content_type_id_ad8f9e9c ON public.analytics_analytics USING btree (content_type_id);


--
-- Name: analytics_analytics_user_id_d88dd9cc; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX analytics_analytics_user_id_d88dd9cc ON public.analytics_analytics USING btree (user_id);


--
-- Name: auth_group_name_a6ea08ec_like; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX auth_group_name_a6ea08ec_like ON public.auth_group USING btree (name varchar_pattern_ops);


--
-- Name: auth_group_permissions_group_id_b120cbf9; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX auth_group_permissions_group_id_b120cbf9 ON public.auth_group_permissions USING btree (group_id);


--
-- Name: auth_group_permissions_permission_id_84c5c92e; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX auth_group_permissions_permission_id_84c5c92e ON public.auth_group_permissions USING btree (permission_id);


--
-- Name: auth_permission_content_type_id_2f476e4b; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX auth_permission_content_type_id_2f476e4b ON public.auth_permission USING btree (content_type_id);


--
-- Name: consumer_requests_customer_id_9915e7f1; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX consumer_requests_customer_id_9915e7f1 ON public.consumer_requests USING btree (customer_id);


--
-- Name: consumer_requests_enterprise_id_5e899e15; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX consumer_requests_enterprise_id_5e899e15 ON public.consumer_requests USING btree (enterprise_id);


--
-- Name: customer_uploads_customer_id_5d297ca6; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX customer_uploads_customer_id_5d297ca6 ON public.customer_uploads USING btree (customer_id);


--
-- Name: customers_elroi_id_31963595_like; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX customers_elroi_id_31963595_like ON public.customers USING btree (elroi_id varchar_pattern_ops);


--
-- Name: customers_email_af8f39bb_like; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX customers_email_af8f39bb_like ON public.customers USING btree (email varchar_pattern_ops);


--
-- Name: django_admin_log_content_type_id_c4bce8eb; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX django_admin_log_content_type_id_c4bce8eb ON public.django_admin_log USING btree (content_type_id);


--
-- Name: django_admin_log_user_id_c564eba6; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX django_admin_log_user_id_c564eba6 ON public.django_admin_log USING btree (user_id);


--
-- Name: django_session_expire_date_a5c62663; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX django_session_expire_date_a5c62663 ON public.django_session USING btree (expire_date);


--
-- Name: django_session_session_key_c0390e0f_like; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX django_session_session_key_c0390e0f_like ON public.django_session USING btree (session_key varchar_pattern_ops);


--
-- Name: enterprise_configuration_enterprise_id_f84fa14f; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX enterprise_configuration_enterprise_id_f84fa14f ON public.enterprise_configuration USING btree (enterprise_id);


--
-- Name: enterprise_customer_configuration_author_id_0102581a; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX enterprise_customer_configuration_author_id_0102581a ON public.enterprise_customer_configuration USING btree (author_id);


--
-- Name: enterprises_elroi_id_0fc0e6d7_like; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX enterprises_elroi_id_0fc0e6d7_like ON public.enterprises USING btree (elroi_id varchar_pattern_ops);


--
-- Name: enterprises_email_1d7a469d_like; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX enterprises_email_1d7a469d_like ON public.enterprises USING btree (email varchar_pattern_ops);


--
-- Name: enterprises_updated_by_id_d9cb6058; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX enterprises_updated_by_id_d9cb6058 ON public.enterprises USING btree (updated_by_id);


--
-- Name: otp_static_staticdevice_user_id_7f9cff2b; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX otp_static_staticdevice_user_id_7f9cff2b ON public.otp_static_staticdevice USING btree (user_id);


--
-- Name: otp_static_statictoken_device_id_74b7c7d1; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX otp_static_statictoken_device_id_74b7c7d1 ON public.otp_static_statictoken USING btree (device_id);


--
-- Name: otp_static_statictoken_token_d0a51866; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX otp_static_statictoken_token_d0a51866 ON public.otp_static_statictoken USING btree (token);


--
-- Name: otp_static_statictoken_token_d0a51866_like; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX otp_static_statictoken_token_d0a51866_like ON public.otp_static_statictoken USING btree (token varchar_pattern_ops);


--
-- Name: otp_totp_totpdevice_user_id_0fb18292; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX otp_totp_totpdevice_user_id_0fb18292 ON public.otp_totp_totpdevice USING btree (user_id);


--
-- Name: token_blacklist_outstandingtoken_jti_hex_d9bdf6f7_like; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX token_blacklist_outstandingtoken_jti_hex_d9bdf6f7_like ON public.token_blacklist_outstandingtoken USING btree (jti varchar_pattern_ops);


--
-- Name: token_blacklist_outstandingtoken_user_id_83bc629a; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX token_blacklist_outstandingtoken_user_id_83bc629a ON public.token_blacklist_outstandingtoken USING btree (user_id);


--
-- Name: user_guide_owner_id_cded9d5a; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX user_guide_owner_id_cded9d5a ON public.user_guide USING btree (owner_id);


--
-- Name: user_guide_uploads_user_guide_id_e5c39be2; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX user_guide_uploads_user_guide_id_e5c39be2 ON public.user_guide_uploads USING btree (user_guide_id);


--
-- Name: accounts_account_groups accounts_account_gro_account_id_52f14852_fk_accounts_; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.accounts_account_groups
    ADD CONSTRAINT accounts_account_gro_account_id_52f14852_fk_accounts_ FOREIGN KEY (account_id) REFERENCES public.accounts_account(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: accounts_account_groups accounts_account_groups_group_id_7c6a6bd1_fk_auth_group_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.accounts_account_groups
    ADD CONSTRAINT accounts_account_groups_group_id_7c6a6bd1_fk_auth_group_id FOREIGN KEY (group_id) REFERENCES public.auth_group(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: accounts_account_user_permissions accounts_account_use_account_id_816f9bde_fk_accounts_; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.accounts_account_user_permissions
    ADD CONSTRAINT accounts_account_use_account_id_816f9bde_fk_accounts_ FOREIGN KEY (account_id) REFERENCES public.accounts_account(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: accounts_account_user_permissions accounts_account_use_permission_id_24620205_fk_auth_perm; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.accounts_account_user_permissions
    ADD CONSTRAINT accounts_account_use_permission_id_24620205_fk_auth_perm FOREIGN KEY (permission_id) REFERENCES public.auth_permission(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: admin_enterprise_config admin_enterprise_con_created_by_id_fba789c9_fk_accounts_; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.admin_enterprise_config
    ADD CONSTRAINT admin_enterprise_con_created_by_id_fba789c9_fk_accounts_ FOREIGN KEY (created_by_id) REFERENCES public.accounts_account(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: admin_enterprise_config admin_enterprise_con_updated_by_id_2cdf5cb5_fk_accounts_; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.admin_enterprise_config
    ADD CONSTRAINT admin_enterprise_con_updated_by_id_2cdf5cb5_fk_accounts_ FOREIGN KEY (updated_by_id) REFERENCES public.accounts_account(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: analytics_activitylog analytics_activitylog_user_id_d7739206_fk_accounts_account_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.analytics_activitylog
    ADD CONSTRAINT analytics_activitylog_user_id_d7739206_fk_accounts_account_id FOREIGN KEY (user_id) REFERENCES public.accounts_account(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: analytics_analytics analytics_analytics_content_type_id_ad8f9e9c_fk_django_co; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.analytics_analytics
    ADD CONSTRAINT analytics_analytics_content_type_id_ad8f9e9c_fk_django_co FOREIGN KEY (content_type_id) REFERENCES public.django_content_type(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: analytics_analytics analytics_analytics_user_id_d88dd9cc_fk_accounts_account_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.analytics_analytics
    ADD CONSTRAINT analytics_analytics_user_id_d88dd9cc_fk_accounts_account_id FOREIGN KEY (user_id) REFERENCES public.accounts_account(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: auth_group_permissions auth_group_permissio_permission_id_84c5c92e_fk_auth_perm; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_group_permissions
    ADD CONSTRAINT auth_group_permissio_permission_id_84c5c92e_fk_auth_perm FOREIGN KEY (permission_id) REFERENCES public.auth_permission(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: auth_group_permissions auth_group_permissions_group_id_b120cbf9_fk_auth_group_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_group_permissions
    ADD CONSTRAINT auth_group_permissions_group_id_b120cbf9_fk_auth_group_id FOREIGN KEY (group_id) REFERENCES public.auth_group(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: auth_permission auth_permission_content_type_id_2f476e4b_fk_django_co; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_permission
    ADD CONSTRAINT auth_permission_content_type_id_2f476e4b_fk_django_co FOREIGN KEY (content_type_id) REFERENCES public.django_content_type(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: consumer_requests consumer_requests_customer_id_9915e7f1_fk_customers_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.consumer_requests
    ADD CONSTRAINT consumer_requests_customer_id_9915e7f1_fk_customers_id FOREIGN KEY (customer_id) REFERENCES public.customers(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: consumer_requests consumer_requests_enterprise_id_5e899e15_fk_enterprises_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.consumer_requests
    ADD CONSTRAINT consumer_requests_enterprise_id_5e899e15_fk_enterprises_id FOREIGN KEY (enterprise_id) REFERENCES public.enterprises(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: customer_uploads customer_uploads_customer_id_5d297ca6_fk_customers_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.customer_uploads
    ADD CONSTRAINT customer_uploads_customer_id_5d297ca6_fk_customers_id FOREIGN KEY (customer_id) REFERENCES public.customers(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: customers customers_user_id_28f6c6eb_fk_accounts_account_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.customers
    ADD CONSTRAINT customers_user_id_28f6c6eb_fk_accounts_account_id FOREIGN KEY (user_id) REFERENCES public.accounts_account(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: django_admin_log django_admin_log_content_type_id_c4bce8eb_fk_django_co; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.django_admin_log
    ADD CONSTRAINT django_admin_log_content_type_id_c4bce8eb_fk_django_co FOREIGN KEY (content_type_id) REFERENCES public.django_content_type(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: django_admin_log django_admin_log_user_id_c564eba6_fk_accounts_account_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.django_admin_log
    ADD CONSTRAINT django_admin_log_user_id_c564eba6_fk_accounts_account_id FOREIGN KEY (user_id) REFERENCES public.accounts_account(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: enterprise_configuration enterprise_configura_enterprise_id_f84fa14f_fk_accounts_; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.enterprise_configuration
    ADD CONSTRAINT enterprise_configura_enterprise_id_f84fa14f_fk_accounts_ FOREIGN KEY (enterprise_id) REFERENCES public.accounts_account(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: enterprise_customer_configuration enterprise_customer__author_id_0102581a_fk_accounts_; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.enterprise_customer_configuration
    ADD CONSTRAINT enterprise_customer__author_id_0102581a_fk_accounts_ FOREIGN KEY (author_id) REFERENCES public.accounts_account(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: enterprises enterprises_updated_by_id_d9cb6058_fk_accounts_account_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.enterprises
    ADD CONSTRAINT enterprises_updated_by_id_d9cb6058_fk_accounts_account_id FOREIGN KEY (updated_by_id) REFERENCES public.accounts_account(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: enterprises enterprises_user_id_c0761346_fk_accounts_account_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.enterprises
    ADD CONSTRAINT enterprises_user_id_c0761346_fk_accounts_account_id FOREIGN KEY (user_id) REFERENCES public.accounts_account(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: otp_static_staticdevice otp_static_staticdevice_user_id_7f9cff2b_fk_accounts_account_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.otp_static_staticdevice
    ADD CONSTRAINT otp_static_staticdevice_user_id_7f9cff2b_fk_accounts_account_id FOREIGN KEY (user_id) REFERENCES public.accounts_account(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: otp_static_statictoken otp_static_statictok_device_id_74b7c7d1_fk_otp_stati; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.otp_static_statictoken
    ADD CONSTRAINT otp_static_statictok_device_id_74b7c7d1_fk_otp_stati FOREIGN KEY (device_id) REFERENCES public.otp_static_staticdevice(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: otp_totp_totpdevice otp_totp_totpdevice_user_id_0fb18292_fk_accounts_account_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.otp_totp_totpdevice
    ADD CONSTRAINT otp_totp_totpdevice_user_id_0fb18292_fk_accounts_account_id FOREIGN KEY (user_id) REFERENCES public.accounts_account(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: token_blacklist_blacklistedtoken token_blacklist_blac_token_id_3cc7fe56_fk_token_bla; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.token_blacklist_blacklistedtoken
    ADD CONSTRAINT token_blacklist_blac_token_id_3cc7fe56_fk_token_bla FOREIGN KEY (token_id) REFERENCES public.token_blacklist_outstandingtoken(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: token_blacklist_outstandingtoken token_blacklist_outs_user_id_83bc629a_fk_accounts_; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.token_blacklist_outstandingtoken
    ADD CONSTRAINT token_blacklist_outs_user_id_83bc629a_fk_accounts_ FOREIGN KEY (user_id) REFERENCES public.accounts_account(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: user_guide user_guide_owner_id_cded9d5a_fk_accounts_account_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_guide
    ADD CONSTRAINT user_guide_owner_id_cded9d5a_fk_accounts_account_id FOREIGN KEY (owner_id) REFERENCES public.accounts_account(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: user_guide_uploads user_guide_uploads_user_guide_id_e5c39be2_fk_user_guide_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_guide_uploads
    ADD CONSTRAINT user_guide_uploads_user_guide_id_e5c39be2_fk_user_guide_id FOREIGN KEY (user_guide_id) REFERENCES public.user_guide(id) DEFERRABLE INITIALLY DEFERRED;


--
-- PostgreSQL database dump complete
--

