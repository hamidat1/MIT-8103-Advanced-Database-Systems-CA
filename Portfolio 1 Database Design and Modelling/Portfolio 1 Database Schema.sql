--
-- PostgreSQL database dump
--

\restrict szWFyWPTRUCLsdGoc406hc6xs4OoRXNRyqzx3pOeUy4m92VxOsOIIwPgCs21ram

-- Dumped from database version 18.6 (Ubuntu 18.6-0ubuntu0.26.04.1)
-- Dumped by pg_dump version 18.6 (Ubuntu 18.6-0ubuntu0.26.04.1)

-- Started on 2026-11-08 03:59:45 WAT

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
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
-- TOC entry 220 (class 1259 OID 16391)
-- Name: branches; Type: TABLE; Schema: public; Owner: fmbn_admin
--

CREATE TABLE public.branches (
    branch_id integer NOT NULL,
    branch_name character varying(100) NOT NULL,
    branch_location character varying(150) NOT NULL,
    branch_phone character varying(20)
);


ALTER TABLE public.branches OWNER TO fmbn_admin;

--
-- TOC entry 219 (class 1259 OID 16390)
-- Name: branches_branch_id_seq; Type: SEQUENCE; Schema: public; Owner: fmbn_admin
--

CREATE SEQUENCE public.branches_branch_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.branches_branch_id_seq OWNER TO fmbn_admin;

--
-- TOC entry 3603 (class 0 OID 0)
-- Dependencies: 219
-- Name: branches_branch_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: fmbn_admin
--

ALTER SEQUENCE public.branches_branch_id_seq OWNED BY public.branches.branch_id;


--
-- TOC entry 222 (class 1259 OID 16401)
-- Name: customers; Type: TABLE; Schema: public; Owner: fmbn_admin
--

CREATE TABLE public.customers (
    customer_id integer NOT NULL,
    branch_id integer NOT NULL,
    first_name character varying(50) NOT NULL,
    last_name character varying(50) NOT NULL,
    email character varying(100),
    phone_number character varying(20),
    residential_address text,
    registration_date date DEFAULT CURRENT_DATE
);


ALTER TABLE public.customers OWNER TO fmbn_admin;

--
-- TOC entry 221 (class 1259 OID 16400)
-- Name: customers_customer_id_seq; Type: SEQUENCE; Schema: public; Owner: fmbn_admin
--

CREATE SEQUENCE public.customers_customer_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.customers_customer_id_seq OWNER TO fmbn_admin;

--
-- TOC entry 3604 (class 0 OID 0)
-- Dependencies: 221
-- Name: customers_customer_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: fmbn_admin
--

ALTER SEQUENCE public.customers_customer_id_seq OWNED BY public.customers.customer_id;


--
-- TOC entry 224 (class 1259 OID 16422)
-- Name: employees; Type: TABLE; Schema: public; Owner: fmbn_admin
--

CREATE TABLE public.employees (
    employee_id integer NOT NULL,
    branch_id integer NOT NULL,
    first_name character varying(50) NOT NULL,
    last_name character varying(50) NOT NULL,
    job_title character varying(100),
    email character varying(100)
);


ALTER TABLE public.employees OWNER TO fmbn_admin;

--
-- TOC entry 223 (class 1259 OID 16421)
-- Name: employees_employee_id_seq; Type: SEQUENCE; Schema: public; Owner: fmbn_admin
--

CREATE SEQUENCE public.employees_employee_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.employees_employee_id_seq OWNER TO fmbn_admin;

--
-- TOC entry 3605 (class 0 OID 0)
-- Dependencies: 223
-- Name: employees_employee_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: fmbn_admin
--

ALTER SEQUENCE public.employees_employee_id_seq OWNED BY public.employees.employee_id;


--
-- TOC entry 230 (class 1259 OID 16478)
-- Name: loan_approvals; Type: TABLE; Schema: public; Owner: fmbn_admin
--

CREATE TABLE public.loan_approvals (
    approval_id integer NOT NULL,
    application_id integer NOT NULL,
    employee_id integer NOT NULL,
    approval_date date DEFAULT CURRENT_DATE,
    approval_status character varying(30) NOT NULL,
    approval_remarks text,
    CONSTRAINT chk_approval_status CHECK (((approval_status)::text = ANY ((ARRAY['Approved'::character varying, 'Rejected'::character varying])::text[])))
);


ALTER TABLE public.loan_approvals OWNER TO fmbn_admin;

--
-- TOC entry 229 (class 1259 OID 16477)
-- Name: loan_approvals_approval_id_seq; Type: SEQUENCE; Schema: public; Owner: fmbn_admin
--

CREATE SEQUENCE public.loan_approvals_approval_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.loan_approvals_approval_id_seq OWNER TO fmbn_admin;

--
-- TOC entry 3606 (class 0 OID 0)
-- Dependencies: 229
-- Name: loan_approvals_approval_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: fmbn_admin
--

ALTER SEQUENCE public.loan_approvals_approval_id_seq OWNED BY public.loan_approvals.approval_id;


--
-- TOC entry 232 (class 1259 OID 16503)
-- Name: loans; Type: TABLE; Schema: public; Owner: fmbn_admin
--

CREATE TABLE public.loans (
    loan_id integer NOT NULL,
    application_id integer NOT NULL,
    loan_amount numeric(15,2) NOT NULL,
    interest_rate numeric(5,2) NOT NULL,
    loan_duration_months integer NOT NULL,
    disbursement_date date,
    loan_status character varying(30) DEFAULT 'Active'::character varying,
    CONSTRAINT chk_interest_rate CHECK ((interest_rate >= (0)::numeric)),
    CONSTRAINT chk_loan_amount CHECK ((loan_amount > (0)::numeric)),
    CONSTRAINT chk_loan_duration CHECK ((loan_duration_months > 0)),
    CONSTRAINT chk_loan_status CHECK (((loan_status)::text = ANY ((ARRAY['Active'::character varying, 'Completed'::character varying, 'Defaulted'::character varying])::text[])))
);


ALTER TABLE public.loans OWNER TO fmbn_admin;

--
-- TOC entry 231 (class 1259 OID 16502)
-- Name: loans_loan_id_seq; Type: SEQUENCE; Schema: public; Owner: fmbn_admin
--

CREATE SEQUENCE public.loans_loan_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.loans_loan_id_seq OWNER TO fmbn_admin;

--
-- TOC entry 3607 (class 0 OID 0)
-- Dependencies: 231
-- Name: loans_loan_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: fmbn_admin
--

ALTER SEQUENCE public.loans_loan_id_seq OWNED BY public.loans.loan_id;


--
-- TOC entry 228 (class 1259 OID 16453)
-- Name: mortgage_applications; Type: TABLE; Schema: public; Owner: fmbn_admin
--

CREATE TABLE public.mortgage_applications (
    application_id integer NOT NULL,
    customer_id integer NOT NULL,
    property_id integer NOT NULL,
    application_date date DEFAULT CURRENT_DATE,
    requested_amount numeric(15,2) NOT NULL,
    application_status character varying(30) DEFAULT 'Pending'::character varying,
    CONSTRAINT chk_application_status CHECK (((application_status)::text = ANY ((ARRAY['Pending'::character varying, 'Approved'::character varying, 'Rejected'::character varying])::text[]))),
    CONSTRAINT chk_requested_amount CHECK ((requested_amount > (0)::numeric))
);


ALTER TABLE public.mortgage_applications OWNER TO fmbn_admin;

--
-- TOC entry 227 (class 1259 OID 16452)
-- Name: mortgage_applications_application_id_seq; Type: SEQUENCE; Schema: public; Owner: fmbn_admin
--

CREATE SEQUENCE public.mortgage_applications_application_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.mortgage_applications_application_id_seq OWNER TO fmbn_admin;

--
-- TOC entry 3608 (class 0 OID 0)
-- Dependencies: 227
-- Name: mortgage_applications_application_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: fmbn_admin
--

ALTER SEQUENCE public.mortgage_applications_application_id_seq OWNED BY public.mortgage_applications.application_id;


--
-- TOC entry 226 (class 1259 OID 16440)
-- Name: properties; Type: TABLE; Schema: public; Owner: fmbn_admin
--

CREATE TABLE public.properties (
    property_id integer NOT NULL,
    property_address text NOT NULL,
    property_type character varying(50),
    property_value numeric(15,2) NOT NULL,
    CONSTRAINT chk_property_value CHECK ((property_value > (0)::numeric))
);


ALTER TABLE public.properties OWNER TO fmbn_admin;

--
-- TOC entry 225 (class 1259 OID 16439)
-- Name: properties_property_id_seq; Type: SEQUENCE; Schema: public; Owner: fmbn_admin
--

CREATE SEQUENCE public.properties_property_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.properties_property_id_seq OWNER TO fmbn_admin;

--
-- TOC entry 3609 (class 0 OID 0)
-- Dependencies: 225
-- Name: properties_property_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: fmbn_admin
--

ALTER SEQUENCE public.properties_property_id_seq OWNED BY public.properties.property_id;


--
-- TOC entry 234 (class 1259 OID 16527)
-- Name: repayments; Type: TABLE; Schema: public; Owner: fmbn_admin
--

CREATE TABLE public.repayments (
    repayment_id integer NOT NULL,
    loan_id integer NOT NULL,
    repayment_date date DEFAULT CURRENT_DATE,
    amount_paid numeric(15,2) NOT NULL,
    payment_method character varying(50),
    payment_reference character varying(100),
    CONSTRAINT chk_amount_paid CHECK ((amount_paid > (0)::numeric))
);


ALTER TABLE public.repayments OWNER TO fmbn_admin;

--
-- TOC entry 233 (class 1259 OID 16526)
-- Name: repayments_repayment_id_seq; Type: SEQUENCE; Schema: public; Owner: fmbn_admin
--

CREATE SEQUENCE public.repayments_repayment_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.repayments_repayment_id_seq OWNER TO fmbn_admin;

--
-- TOC entry 3610 (class 0 OID 0)
-- Dependencies: 233
-- Name: repayments_repayment_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: fmbn_admin
--

ALTER SEQUENCE public.repayments_repayment_id_seq OWNED BY public.repayments.repayment_id;


--
-- TOC entry 3395 (class 2604 OID 16394)
-- Name: branches branch_id; Type: DEFAULT; Schema: public; Owner: fmbn_admin
--

ALTER TABLE ONLY public.branches ALTER COLUMN branch_id SET DEFAULT nextval('public.branches_branch_id_seq'::regclass);


--
-- TOC entry 3396 (class 2604 OID 16404)
-- Name: customers customer_id; Type: DEFAULT; Schema: public; Owner: fmbn_admin
--

ALTER TABLE ONLY public.customers ALTER COLUMN customer_id SET DEFAULT nextval('public.customers_customer_id_seq'::regclass);


--
-- TOC entry 3398 (class 2604 OID 16425)
-- Name: employees employee_id; Type: DEFAULT; Schema: public; Owner: fmbn_admin
--

ALTER TABLE ONLY public.employees ALTER COLUMN employee_id SET DEFAULT nextval('public.employees_employee_id_seq'::regclass);


--
-- TOC entry 3403 (class 2604 OID 16481)
-- Name: loan_approvals approval_id; Type: DEFAULT; Schema: public; Owner: fmbn_admin
--

ALTER TABLE ONLY public.loan_approvals ALTER COLUMN approval_id SET DEFAULT nextval('public.loan_approvals_approval_id_seq'::regclass);


--
-- TOC entry 3405 (class 2604 OID 16506)
-- Name: loans loan_id; Type: DEFAULT; Schema: public; Owner: fmbn_admin
--

ALTER TABLE ONLY public.loans ALTER COLUMN loan_id SET DEFAULT nextval('public.loans_loan_id_seq'::regclass);


--
-- TOC entry 3400 (class 2604 OID 16456)
-- Name: mortgage_applications application_id; Type: DEFAULT; Schema: public; Owner: fmbn_admin
--

ALTER TABLE ONLY public.mortgage_applications ALTER COLUMN application_id SET DEFAULT nextval('public.mortgage_applications_application_id_seq'::regclass);


--
-- TOC entry 3399 (class 2604 OID 16443)
-- Name: properties property_id; Type: DEFAULT; Schema: public; Owner: fmbn_admin
--

ALTER TABLE ONLY public.properties ALTER COLUMN property_id SET DEFAULT nextval('public.properties_property_id_seq'::regclass);


--
-- TOC entry 3407 (class 2604 OID 16530)
-- Name: repayments repayment_id; Type: DEFAULT; Schema: public; Owner: fmbn_admin
--

ALTER TABLE ONLY public.repayments ALTER COLUMN repayment_id SET DEFAULT nextval('public.repayments_repayment_id_seq'::regclass);


--
-- TOC entry 3419 (class 2606 OID 16399)
-- Name: branches branches_pkey; Type: CONSTRAINT; Schema: public; Owner: fmbn_admin
--

ALTER TABLE ONLY public.branches
    ADD CONSTRAINT branches_pkey PRIMARY KEY (branch_id);


--
-- TOC entry 3421 (class 2606 OID 16415)
-- Name: customers customers_email_key; Type: CONSTRAINT; Schema: public; Owner: fmbn_admin
--

ALTER TABLE ONLY public.customers
    ADD CONSTRAINT customers_email_key UNIQUE (email);


--
-- TOC entry 3423 (class 2606 OID 16413)
-- Name: customers customers_pkey; Type: CONSTRAINT; Schema: public; Owner: fmbn_admin
--

ALTER TABLE ONLY public.customers
    ADD CONSTRAINT customers_pkey PRIMARY KEY (customer_id);


--
-- TOC entry 3425 (class 2606 OID 16433)
-- Name: employees employees_email_key; Type: CONSTRAINT; Schema: public; Owner: fmbn_admin
--

ALTER TABLE ONLY public.employees
    ADD CONSTRAINT employees_email_key UNIQUE (email);


--
-- TOC entry 3427 (class 2606 OID 16431)
-- Name: employees employees_pkey; Type: CONSTRAINT; Schema: public; Owner: fmbn_admin
--

ALTER TABLE ONLY public.employees
    ADD CONSTRAINT employees_pkey PRIMARY KEY (employee_id);


--
-- TOC entry 3434 (class 2606 OID 16491)
-- Name: loan_approvals loan_approvals_pkey; Type: CONSTRAINT; Schema: public; Owner: fmbn_admin
--

ALTER TABLE ONLY public.loan_approvals
    ADD CONSTRAINT loan_approvals_pkey PRIMARY KEY (approval_id);


--
-- TOC entry 3436 (class 2606 OID 16520)
-- Name: loans loans_application_id_key; Type: CONSTRAINT; Schema: public; Owner: fmbn_admin
--

ALTER TABLE ONLY public.loans
    ADD CONSTRAINT loans_application_id_key UNIQUE (application_id);


--
-- TOC entry 3438 (class 2606 OID 16518)
-- Name: loans loans_pkey; Type: CONSTRAINT; Schema: public; Owner: fmbn_admin
--

ALTER TABLE ONLY public.loans
    ADD CONSTRAINT loans_pkey PRIMARY KEY (loan_id);


--
-- TOC entry 3432 (class 2606 OID 16466)
-- Name: mortgage_applications mortgage_applications_pkey; Type: CONSTRAINT; Schema: public; Owner: fmbn_admin
--

ALTER TABLE ONLY public.mortgage_applications
    ADD CONSTRAINT mortgage_applications_pkey PRIMARY KEY (application_id);


--
-- TOC entry 3429 (class 2606 OID 16451)
-- Name: properties properties_pkey; Type: CONSTRAINT; Schema: public; Owner: fmbn_admin
--

ALTER TABLE ONLY public.properties
    ADD CONSTRAINT properties_pkey PRIMARY KEY (property_id);


--
-- TOC entry 3440 (class 2606 OID 16539)
-- Name: repayments repayments_payment_reference_key; Type: CONSTRAINT; Schema: public; Owner: fmbn_admin
--

ALTER TABLE ONLY public.repayments
    ADD CONSTRAINT repayments_payment_reference_key UNIQUE (payment_reference);


--
-- TOC entry 3442 (class 2606 OID 16537)
-- Name: repayments repayments_pkey; Type: CONSTRAINT; Schema: public; Owner: fmbn_admin
--

ALTER TABLE ONLY public.repayments
    ADD CONSTRAINT repayments_pkey PRIMARY KEY (repayment_id);


--
-- TOC entry 3430 (class 1259 OID 16545)
-- Name: idx_mortgage_requested_amount; Type: INDEX; Schema: public; Owner: fmbn_admin
--

CREATE INDEX idx_mortgage_requested_amount ON public.mortgage_applications USING btree (requested_amount);


--
-- TOC entry 3445 (class 2606 OID 16467)
-- Name: mortgage_applications fk_application_customer; Type: FK CONSTRAINT; Schema: public; Owner: fmbn_admin
--

ALTER TABLE ONLY public.mortgage_applications
    ADD CONSTRAINT fk_application_customer FOREIGN KEY (customer_id) REFERENCES public.customers(customer_id);


--
-- TOC entry 3446 (class 2606 OID 16472)
-- Name: mortgage_applications fk_application_property; Type: FK CONSTRAINT; Schema: public; Owner: fmbn_admin
--

ALTER TABLE ONLY public.mortgage_applications
    ADD CONSTRAINT fk_application_property FOREIGN KEY (property_id) REFERENCES public.properties(property_id);


--
-- TOC entry 3447 (class 2606 OID 16492)
-- Name: loan_approvals fk_approval_application; Type: FK CONSTRAINT; Schema: public; Owner: fmbn_admin
--

ALTER TABLE ONLY public.loan_approvals
    ADD CONSTRAINT fk_approval_application FOREIGN KEY (application_id) REFERENCES public.mortgage_applications(application_id);


--
-- TOC entry 3448 (class 2606 OID 16497)
-- Name: loan_approvals fk_approval_employee; Type: FK CONSTRAINT; Schema: public; Owner: fmbn_admin
--

ALTER TABLE ONLY public.loan_approvals
    ADD CONSTRAINT fk_approval_employee FOREIGN KEY (employee_id) REFERENCES public.employees(employee_id);


--
-- TOC entry 3443 (class 2606 OID 16416)
-- Name: customers fk_customer_branch; Type: FK CONSTRAINT; Schema: public; Owner: fmbn_admin
--

ALTER TABLE ONLY public.customers
    ADD CONSTRAINT fk_customer_branch FOREIGN KEY (branch_id) REFERENCES public.branches(branch_id);


--
-- TOC entry 3444 (class 2606 OID 16434)
-- Name: employees fk_employee_branch; Type: FK CONSTRAINT; Schema: public; Owner: fmbn_admin
--

ALTER TABLE ONLY public.employees
    ADD CONSTRAINT fk_employee_branch FOREIGN KEY (branch_id) REFERENCES public.branches(branch_id);


--
-- TOC entry 3449 (class 2606 OID 16521)
-- Name: loans fk_loan_application; Type: FK CONSTRAINT; Schema: public; Owner: fmbn_admin
--

ALTER TABLE ONLY public.loans
    ADD CONSTRAINT fk_loan_application FOREIGN KEY (application_id) REFERENCES public.mortgage_applications(application_id);


--
-- TOC entry 3450 (class 2606 OID 16540)
-- Name: repayments fk_repayment_loan; Type: FK CONSTRAINT; Schema: public; Owner: fmbn_admin
--

ALTER TABLE ONLY public.repayments
    ADD CONSTRAINT fk_repayment_loan FOREIGN KEY (loan_id) REFERENCES public.loans(loan_id);


-- Completed on 2026-11-08 03:59:45 WAT

--
-- PostgreSQL database dump complete
--

\unrestrict szWFyWPTRUCLsdGoc406hc6xs4OoRXNRyqzx3pOeUy4m92VxOsOIIwPgCs21ram

