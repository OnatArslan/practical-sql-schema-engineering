create table users
(
    id           uuid primary key,
    email        varchar(100) not null,
    display_name varchar(100) not null,
    created_at   timestamptz  not null default now(),

    constraint uq_user_email unique (email)
);


create table projects
(
    id         uuid primary key,
    name       varchar(200) not null,
    created_at timestamptz  not null default now(),
    updated_at timestamptz  not null default now()


);

create table project_members
(
  project_id uuid not null,
  user_id uuid not null,
  role varchar(30) not null,

  constraint pk_project_member_project_user primary key (project_id, user_id),

  constraint  ck_project_member_role check ( role in ('MEMBER', 'OWNER', 'ADMIN') )


);



create table todos
(
    id         uuid primary key,
    project_id uuid not null,
    title      varchar(200)     not null,
    status     varchar(20)      not null default 'TODO',
    created_at timestamptz      not null default now(),
    priority integer,
    completed_at timestamptz,

    constraint ck_todos_completion check (
        (status = 'DONE' and completed_at is not null)
        or
        (status <> 'DONE' and completed_at is null)
        ),

    constraint fk_todos_project foreign key (project_id) references projects (id),

    constraint ck_todos_status check ( status in ('TODO', 'IN_PROGRESS', 'DONE') ),

    constraint ck_todos_priority check (
        (priority is not null)
            and
        (priority between 1 and 5)
        )



);

create index ix_todo_project on todos (project_id);


